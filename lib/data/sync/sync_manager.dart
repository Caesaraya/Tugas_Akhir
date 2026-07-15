// lib/data/sync/sync_manager.dart
//
// SyncManager TIDAK tahu apa-apa tentang Transaction, Product, atau modul
// lainnya. Ia hanya tahu: "ada baris pending dengan entity_type X, panggil
// handler yang terdaftar untuk X". Setiap Repository yang butuh sync
// mendaftarkan dirinya sendiri lewat registerHandler() saat bootstrap
// aplikasi (lihat bootstrap.dart). Modul baru = tambah satu baris registrasi,
// TANPA mengubah file ini sama sekali.
//
// Diproses satu-per-satu secara berurutan (bukan Future.wait / paralel):
// jika transaksi ke-3 gagal (mis. stok sudah habis di server), transaksi
// ke-1, ke-2, ke-4, dst tetap lanjut tersinkron. Kegagalan satu baris
// di-catch per-baris dan tidak menghentikan loop.

import 'sync_queue_service.dart';

/// Handler mengembalikan hasil sukses/gagal + data tambahan opsional
/// (mis. server id) yang akan diteruskan ke [onSynced] milik entity itu.
typedef SyncHandler = Future<SyncResult> Function(SyncQueueRow row);

class SyncResult {
  final bool success;
  final String? error;
  final Map<String, dynamic>? serverData;

  SyncResult.success([this.serverData]) : success = true, error = null;
  SyncResult.failure(this.error) : success = false, serverData = null;
}

class SyncManager {
  SyncManager._internal();
  static final SyncManager instance = SyncManager._internal();

  final SyncQueueService _queueService = SyncQueueService();
  final Map<String, SyncHandler> _handlers = {};

  bool _isSyncing = false;

  /// Dipanggil sekali per entity_type saat bootstrap, misal:
  /// SyncManager.instance.registerHandler('transaction', TransactionRepository.instance.syncOne);
  void registerHandler(String entityType, SyncHandler handler) {
    _handlers[entityType] = handler;
  }

  Future<void> runSync() async {
    if (_isSyncing) return; // cegah dua proses sync jalan bersamaan
    _isSyncing = true;

    try {
      final pending = await _queueService.getPendingOrdered();

      for (final row in pending) {
        await _processOne(row);
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _processOne(SyncQueueRow row) async {
    final handler = _handlers[row.entityType];

    if (handler == null) {
      // Tidak ada repository yang terdaftar untuk entity_type ini.
      // Dibiarkan pending — begitu modul terkait registerHandler(),
      // baris ini akan otomatis terproses di sync berikutnya.
      return;
    }

    await _queueService.markSyncing(row.id);

    try {
      final result = await handler(row);

      if (result.success) {
        await _queueService.markSynced(row.id);
      } else {
        await _queueService.markFailed(
          row.id,
          row.retryCount,
          result.error ?? 'unknown error',
        );
      }
    } catch (e) {
      // Exception tak terduga (mis. timeout) tetap dianggap kegagalan
      // baris ini saja, loop lanjut ke baris berikutnya.
      await _queueService.markFailed(row.id, row.retryCount, e.toString());
    }
  }
}
