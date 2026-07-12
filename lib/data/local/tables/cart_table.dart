// lib/data/local/tables/cart_table.dart
//
// Cart HANYA untuk durability lokal (agar tidak hilang jika app crash/mati
// listrik di tengah transaksi). Tabel ini TIDAK PERNAH dibaca oleh SyncManager
// dan TIDAK PERNAH masuk sync_queue — checkout membaca dari sini untuk
// membangun payload, lalu memanggil clearCart() yang mengosongkan tabel ini.

class CartTable {
  static const String tableName = 'cart_items_local';

  static const String createTableQuery =
      '''
    CREATE TABLE $tableName (
      product_id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      price INTEGER NOT NULL,
      discount INTEGER NOT NULL DEFAULT 0,
      qty INTEGER NOT NULL DEFAULT 1
    )
  ''';
}
