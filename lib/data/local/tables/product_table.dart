// lib/data/local/tables/product_table.dart
//
// Skema tabel lokal untuk Product (master data).
// Ini adalah CACHE dari server, bukan sumber kebenaran untuk stok final —
// lihat catatan di ProductRepository.refreshFromServer().

class ProductTable {
  static const String tableName = 'products';

  static const String createTableQuery =
      '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      price INTEGER NOT NULL,
      discount INTEGER NOT NULL DEFAULT 0,
      price_after_discount INTEGER NOT NULL DEFAULT 0,
      stock INTEGER NOT NULL DEFAULT 0,
      jenis TEXT NOT NULL DEFAULT '',
      satuan TEXT NOT NULL DEFAULT '',
      image TEXT NOT NULL DEFAULT '',
      resep_id INTEGER,
      deleted_at TEXT,
      updated_locally_at TEXT
    )
  ''';
}
