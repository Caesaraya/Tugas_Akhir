// lib/data/sync/bootstrap.dart
//
// Panggil initOfflineFirst() SEKALI di main(), sebelum runApp(). Ini tempat
// SATU-SATUNYA yang menghubungkan Repository ke SyncManager -- kalau nanti
// menambah modul baru (Produk, Bahan Baku, dst), cukup tambah satu baris
// registerHandler() di sini, tidak perlu mengubah SyncManager itu sendiri.

import 'sync_manager.dart';
import 'connectivity_service.dart';
import '../repository/product_repository.dart';
import '../repository/transaction_repository.dart';

Future<void> initOfflineFirst() async {
  // 1. Daftarkan handler per entity_type.
  SyncManager.instance.registerHandler(
    TransactionRepository.entityType,
    TransactionRepository.instance.syncOne,
  );

  // 2. Mulai dengarkan perubahan konektivitas -- begitu online kembali,
  //    ConnectivityService otomatis memicu SyncManager.runSync().
  ConnectivityService.instance.start();

  // 3. Jika app dibuka dalam keadaan online, coba refresh master data
  //    produk dan jalankan sync sekali di awal (jaring pengaman selain
  //    trigger reconnect). Dibungkus try/catch supaya app tetap start
  //    dengan lancar walau ini gagal (mis. baru nyala tanpa internet).
  try {
    final online = await ConnectivityService.instance.isOnline;
    if (online) {
      await ProductRepository.instance.refreshFromServer();
      await SyncManager.instance.runSync();
    }
  } catch (_) {
    // Diamkan -- app tetap jalan dari data lokal.
  }
}
