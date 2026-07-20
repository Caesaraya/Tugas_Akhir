// lib/data/repository/cart_repository.dart
//
// Cart di sini murni untuk durability (survive app restart/crash), BUKAN
// untuk sinkronisasi. Tidak ada method sync/enqueue di file ini sama sekali —
// itu sengaja, sesuai keputusan #4.

import 'package:sqflite/sqflite.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import '../local/tables/cart_table.dart';
import 'base_repository.dart';

class CartRepository extends BaseRepository {
  CartRepository._internal();
  static final CartRepository instance = CartRepository._internal();

  Future<List<CartItem>> getCart() async {
    final database = await db;
    final rows = await database.query(CartTable.tableName);
    return rows
        .map(
          (r) => CartItem(
            productId: r['product_id'] as int,
            name: r['name'] as String,
            price: r['price'] as int,
            discount: r['discount'] as int,
            qty: r['qty'] as int,
            stock: r['stock'] as int,
          ),
        )
        .toList();
  }

  Future<void> upsertItem(CartItem item) async {
    final database = await db;
    await database.insert(CartTable.tableName, {
      'product_id': item.productId,
      'name': item.name,
      'price': item.price,
      'discount': item.discount,
      'qty': item.qty,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeItem(int productId) async {
    final database = await db;
    await database.delete(
      CartTable.tableName,
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<void> clear() async {
    final database = await db;
    await database.delete(CartTable.tableName);
  }
}
