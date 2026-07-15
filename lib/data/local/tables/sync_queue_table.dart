// lib/data/local/tables/sync_queue_table.dart
//
// Antrean generik untuk SEMUA entity yang perlu disinkronkan ke server.
// SyncManager tidak tahu apa-apa tentang "transaction" secara spesifik —
// ia hanya tahu ada baris dengan entity_type tertentu dan memanggil handler
// yang terdaftar untuk entity_type itu. Ini yang membuat modul baru (Produk,
// Bahan Baku, dst di masa depan) bisa numpang tanpa mengubah SyncManager.

class SyncQueueTable {
  static const String tableName = 'sync_queue';

  static const String createTableQuery =
      '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      operation TEXT NOT NULL,
      payload TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'pending',
      retry_count INTEGER NOT NULL DEFAULT 0,
      last_error TEXT,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      synced_at TEXT
    )
  ''';

  // status yang valid: 'pending' | 'syncing' | 'synced' | 'failed'
  static const int maxRetryBeforeFailed = 5;
}
