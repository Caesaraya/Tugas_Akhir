// lib/data/repository/transaction_repository.dart
//
// Ini satu-satunya tempat yang tahu format payload yang dibutuhkan backend
// untuk endpoint transaksi. Checkout() menulis ke SQLite dulu (localId,
// status 'pending'), lalu enqueueSync() — TIDAK PERNAH memanggil ApiService
// langsung dari sini secara sinkron saat checkout. Pengiriman ke server
// selalu lewat SyncManager, kapan pun koneksi tersedia.
//
// syncOne() adalah handler yang didaftarkan ke SyncManager
// (lihat bootstrap.dart) — inilah yang benar-benar memanggil ApiService.

import 'package:uuid/uuid.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import '../local/tables/transaction_table.dart';
import '../local/tables/transaction_detail_table.dart';
import 'base_repository.dart';
import 'product_repository.dart';
import '../sync/sync_manager.dart';
import '../sync/sync_queue_service.dart';

class TransactionRepository extends BaseRepository {
  TransactionRepository._internal();
  static final TransactionRepository instance =
      TransactionRepository._internal();

  static const String entityType = 'transaction';
  static const _uuid = Uuid();

  /// Dipanggil dari CartController saat kasir menekan "Selesai".
  /// Mengembalikan localId transaksi yang baru dibuat.
  Future<String> checkout({
    required List<CartItem> cart,
    required double total,
    required double bayar,
    required double kembalian,
    required String metode,
  }) async {
    final localId = _uuid.v4();
    final now = DateTime.now();
    final database = await db;

    await database.transaction((txn) async {
      // 1. Simpan header transaksi, status pending.
      await txn.insert(TransactionTable.tableName, {
        'local_id': localId,
        'server_id': null,
        'tanggal': now.toIso8601String(),
        'total_harga': total,
        'jumlah_bayar': bayar,
        'kembalian': kembalian,
        'metode_pembayaran': metode,
        'status': 'pending',
        'created_at': now.toIso8601String(),
      });

      // 2. Simpan detail item, ikut transaction_local_id yang sama.
      final batch = txn.batch();
      for (final item in cart) {
        batch.insert(TransactionDetailTable.tableName, {
          'transaction_local_id': localId,
          'product_id': item.productId,
          'name': item.name,
          'qty': item.qty,
          'price': item.price.toDouble(),
          'subtotal': item.total,
          'discount': item.discount.toDouble(),
        });
      }
      await batch.commit(noResult: true);
    });

    // 3. Kurangi stok lokal secara optimis (di luar transaction block agar
    //    ProductRepository bebas mengelola koneksinya sendiri).
    for (final item in cart) {
      await ProductRepository.instance.decrementStockLocally(
        item.productId,
        item.qty,
      );
    }

    // 4. Daftarkan ke sync_queue — SATU baris untuk transaction + details
    //    sekaligus (sesuai kontrak createTransaction yang sudah menerima
    //    `items` dalam satu body). Tidak ada baris terpisah untuk detail.
    await enqueueSync(
      entityType: entityType,
      entityId: localId,
      operation: 'INSERT',
      payload: {
        'total_harga': total,
        'metode_pembayaran': metode,
        'jumlah_bayar': bayar,
        'kembalian': kembalian,
        'items': cart
            .map(
              (item) => {
                'product_id': item.productId,
                'qty': item.qty,
                'price': item.price,
                'subtotal': item.total,
              },
            )
            .toList(),
      },
    );

    return localId;
  }

  /// Handler yang dipanggil SyncManager untuk tiap baris sync_queue
  /// dengan entity_type == 'transaction'. Mengembalikan SyncResult, tidak
  /// pernah men-throw ke pemanggil (SyncManager sudah wrap try/catch juga,
  /// tapi di sini kita tangani biar error message lebih jelas).
  Future<SyncResult> syncOne(SyncQueueRow row) async {
    try {
      final payload = row.payload;
      final createdId = await ApiService.createTransactionAndGetId(
        total: (payload['total_harga'] as num).toDouble(),
        bayar: (payload['jumlah_bayar'] as num).toDouble(),
        kembalian: (payload['kembalian'] as num).toDouble(),
        metode: payload['metode_pembayaran'] as String,
        items: (payload['items'] as List).cast<Map<String, dynamic>>(),
      );

      if (createdId == null) {
        return SyncResult.failure('Backend menolak transaksi (lihat log)');
      }

      // Simpan server_id balik ke baris transaksi lokal.
      final database = await db;
      await database.update(
        TransactionTable.tableName,
        {'server_id': createdId, 'status': 'synced'},
        where: 'local_id = ?',
        whereArgs: [row.entityId],
      );

      // Setelah transaksi ini sukses tersinkron, refresh master data produk
      // supaya stok lokal kembali mengikuti angka asli di server (keputusan #2).
      await ProductRepository.instance.refreshFromServer();

      return SyncResult.success({'server_id': createdId});
    } catch (e) {
      return SyncResult.failure(e.toString());
    }
  }

  /// Dibaca oleh Riwayat/Dashboard. Sengaja tidak ada tabel/queue terpisah
  /// untuk "riwayat" atau "dashboard activity" — keduanya cukup query dari
  /// tabel ini, karena datanya memang sama (lihat penjelasan di chat).
  Future<List<Map<String, dynamic>>> getAllLocal() async {
    final database = await db;
    return database.query(
      TransactionTable.tableName,
      orderBy: 'created_at DESC',
    );
  }
}
