// lib/data/repository/product_repository.dart
//
// Product adalah MASTER DATA: arah sinkronisasi kebalikan dari Transaction —
// server -> lokal, bukan lokal -> server. Karena itu Product TIDAK lewat
// sync_queue/SyncManager sama sekali; ia punya mekanisme refresh sendiri
// yang dipanggil (a) saat app start jika online, dan (b) oleh
// TransactionRepository setelah sebuah transaksi berhasil sync, untuk
// mengoreksi stok lokal supaya kembali mengikuti server (lihat penjelasan
// keputusan #2 di chat).
//
// Stok yang dikurangi optimis saat checkout offline TETAP hanya prediksi
// lokal — begitu online, refreshFromServer() adalah satu-satunya yang
// dianggap benar.

import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import '../local/tables/product_table.dart';
import 'base_repository.dart';

class ProductRepository extends BaseRepository {
  ProductRepository._internal();
  static final ProductRepository instance = ProductRepository._internal();

  /// UI selalu baca dari sini — cepat, jalan offline, tidak pernah menunggu HTTP.
  Future<List<Product>> getLocalProducts() async {
    final database = await db;
    final rows = await database.query(ProductTable.tableName);
    return rows.map(_mapToProduct).toList();
  }

  /// Dipanggil saat online (bootstrap, reconnect, atau setelah transaksi
  /// sukses sync). Mengambil data terbaru dari backend lalu replace isi
  /// tabel lokal. Kalau gagal (mis. request timeout), UI tetap punya data
  /// lama di SQLite — tidak ada efek samping.
  Future<void> refreshFromServer() async {
    try {
      final products = await ApiService.getProducts();
      final database = await db;

      await database.transaction((txn) async {
        await txn.delete(ProductTable.tableName);
        final batch = txn.batch();
        for (final p in products) {
          batch.insert(ProductTable.tableName, _productToMap(p));
        }
        await batch.commit(noResult: true);
      });
    } catch (_) {
      // Sengaja ditelan: refresh gagal bukan error fatal, data lokal lama
      // masih valid untuk dipakai kasir. Repository lain (mis. Dashboard)
      // yang butuh tahu status refresh bisa expose Stream terpisah nanti.
    }
  }

  /// Update stok lokal secara optimis begitu item dibeli (dipanggil oleh
  /// TransactionRepository.checkout()), agar produk lain yang stoknya
  /// mepet tidak ke-oversell selama masih offline.
  Future<void> decrementStockLocally(int productId, int qty) async {
    final database = await db;
    await database.rawUpdate(
      'UPDATE ${ProductTable.tableName} SET stock = MAX(stock - ?, 0) WHERE id = ?',
      [qty, productId],
    );
  }

  Product _mapToProduct(Map<String, dynamic> row) {
    return Product(
      id: row['id'] as int,
      name: row['name'] as String,
      price: row['price'] as int,
      discount: row['discount'] as int,
      priceAfterDiscount: row['price_after_discount'] as int,
      stock: row['stock'] as int,
      jenis: row['jenis'] as String,
      satuan: row['satuan'] as String,
      image: row['image'] as String,
      resepId: row['resep_id'] as int?,
      deletedAt: row['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> _productToMap(Product p) {
    return {
      'id': p.id,
      'name': p.name,
      'price': p.price,
      'discount': p.discount,
      'price_after_discount': p.priceAfterDiscount,
      'stock': p.stock,
      'jenis': p.jenis,
      'satuan': p.satuan,
      'image': p.image,
      'resep_id': p.resepId,
      'deleted_at': p.deletedAt,
      'updated_locally_at': DateTime.now().toIso8601String(),
    };
  }
}
