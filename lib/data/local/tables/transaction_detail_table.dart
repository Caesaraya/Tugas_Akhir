// lib/data/local/tables/transaction_detail_table.dart
//
// Detail item selalu menempel ke transaksi lewat `transaction_local_id`
// (bukan server_id, karena server_id belum tentu ada saat baris ini dibuat).

class TransactionDetailTable {
  static const String tableName = 'transaction_details_local';

  static const String createTableQuery =
      '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      transaction_local_id TEXT NOT NULL,
      product_id INTEGER NOT NULL,
      name TEXT NOT NULL,
      qty INTEGER NOT NULL,
      price REAL NOT NULL,
      subtotal REAL NOT NULL,
      discount REAL NOT NULL DEFAULT 0,
      FOREIGN KEY (transaction_local_id)
        REFERENCES ${_txRef}(local_id) ON DELETE CASCADE
    )
  ''';

  // Dipisah agar tidak circular-import ke TransactionTable, cukup nama tabel.
  static const String _txRef = 'transactions_local';
}
