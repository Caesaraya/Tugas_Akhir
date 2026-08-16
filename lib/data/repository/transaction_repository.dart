// lib/data/repository/transaction_repository.dart

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

    for (final item in cart) {
      await ProductRepository.instance.decrementStockLocally(
        item.productId,
        item.qty,
      );
    }

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

      final database = await db;
      await database.update(
        TransactionTable.tableName,
        {'server_id': createdId, 'status': 'synced'},
        where: 'local_id = ?',
        whereArgs: [row.entityId],
      );

      await ProductRepository.instance.refreshFromServer();

      return SyncResult.success({'server_id': createdId});
    } catch (e) {
      return SyncResult.failure(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAllLocal() async {
    final database = await db;
    return database.query(
      TransactionTable.tableName,
      orderBy: 'created_at DESC',
    );
  }

  /// Mengambil semua transaksi beserta rincian produk dan tipe data aman untuk UI
  Future<List<Map<String, dynamic>>> getAllLocalWithDetails() async {
    final database = await db;

    final List<Map<String, dynamic>> headers = await database.query(
      TransactionTable.tableName,
      orderBy: 'created_at DESC',
    );

    List<Map<String, dynamic>> result = [];

    for (var header in headers) {
      final String localId = header['local_id'] as String;

      final List<Map<String, dynamic>> details = await database.query(
        TransactionDetailTable.tableName,
        where: 'transaction_local_id = ?',
        whereArgs: [localId],
      );

      Map<String, dynamic> trxData = Map<String, dynamic>.from(header);

      trxData['id'] = (header['server_id'] ?? header['local_id']).toString();

      trxData['items'] = details.map((item) {
        return {
          'id': item['id'],
          'product_id': item['product_id'],
          'name': item['name'],
          'nama_produk': item['name'],
          'qty': item['qty'],
          'quantity': item['qty'],
          'price': item['price'],
          'subtotal': item['subtotal'],
          'discount': item['discount'],
        };
      }).toList();

      result.add(trxData);
    }

    return result;
  }
}
