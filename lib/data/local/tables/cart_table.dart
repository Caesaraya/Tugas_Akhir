class CartTable {
  static const String tableName = 'cart_items_local';

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      product_id INTEGER PRIMARY KEY,
      name TEXT NOT NULL,
      price INTEGER NOT NULL,
      discount INTEGER NOT NULL DEFAULT 0,
      qty INTEGER NOT NULL DEFAULT 1,
      stock INTEGER NOT NULL DEFAULT 0
    )
  ''';
}