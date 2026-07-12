// lib/data/sync/sync_queue_service.dart
//
// Lapisan tipis di atas tabel sync_queue, dipakai HANYA oleh SyncManager.
// Repository tidak pernah membaca sync_queue langsung (Repository cuma
// menulis lewat BaseRepository.enqueueSync) — pemisahan ini menjaga arah
// dependency tetap satu arah: Repository -> queue -> SyncManager.

import 'dart:convert';
import '../local/app_database.dart';
import '../local/tables/sync_queue_table.dart';

class SyncQueueRow {
  final int id;
  final String entityType;
  final String entityId;
  final String operation;
  final Map<String, dynamic> payload;
  final int retryCount;

  SyncQueueRow({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.retryCount,
  });

  factory SyncQueueRow.fromMap(Map<String, dynamic> map) {
    return SyncQueueRow(
      id: map['id'] as int,
      entityType: map['entity_type'] as String,
      entityId: map['entity_id'] as String,
      operation: map['operation'] as String,
      payload: jsonDecode(map['payload'] as String) as Map<String, dynamic>,
      retryCount: map['retry_count'] as int,
    );
  }
}

class SyncQueueService {
  Future<List<SyncQueueRow>> getPendingOrdered() async {
    final database = await AppDatabase.instance.database;
    final rows = await database.query(
      SyncQueueTable.tableName,
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'created_at ASC', // FIFO — poin utama supaya urutan terjaga
    );
    return rows.map((r) => SyncQueueRow.fromMap(r)).toList();
  }

  Future<void> markSyncing(int id) async {
    final database = await AppDatabase.instance.database;
    await database.update(
      SyncQueueTable.tableName,
      {'status': 'syncing', 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markSynced(int id) async {
    final database = await AppDatabase.instance.database;
    final now = DateTime.now().toIso8601String();
    await database.update(
      SyncQueueTable.tableName,
      {'status': 'synced', 'updated_at': now, 'synced_at': now},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Gagal sync satu baris: naikkan retry_count. Setelah melewati batas,
  /// tandai 'failed' supaya tidak dicoba ulang selamanya (mis. transaksi
  /// yang memang ditolak backend karena stok sudah habis di server).
  Future<void> markFailed(int id, int currentRetryCount, String error) async {
    final database = await AppDatabase.instance.database;
    final nextRetry = currentRetryCount + 1;
    final status = nextRetry >= SyncQueueTable.maxRetryBeforeFailed
        ? 'failed'
        : 'pending';

    await database.update(
      SyncQueueTable.tableName,
      {
        'status': status,
        'retry_count': nextRetry,
        'last_error': error,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
