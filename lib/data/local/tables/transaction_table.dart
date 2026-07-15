// lib/data/local/tables/transaction_table.dart
//
// `local_id` (UUID) adalah primary key — dibuat di device saat checkout,
// SEBELUM tahu id dari server. `server_id` awalnya NULL dan diisi oleh
// SyncManager setelah baris ini berhasil dikirim ke backend.
//
// Kolom `status` di tabel ini (bukan hanya di sync_queue) sengaja dibuat
// redundan: agar UI (Riwayat, Dashboard) bisa membaca status "pending/synced"
// langsung dari satu tabel tanpa perlu JOIN ke sync_queue setiap render.

class TransactionTable {
  static const String tableName = 'transactions_local';

  static const String createTableQuery =
      '''
    CREATE TABLE $tableName (
      local_id TEXT PRIMARY KEY,
      server_id INTEGER,
      tanggal TEXT NOT NULL,
      total_harga REAL NOT NULL,
      jumlah_bayar REAL NOT NULL,
      kembalian REAL NOT NULL,
      metode_pembayaran TEXT NOT NULL,
      status TEXT NOT NULL DEFAULT 'pending',
      created_at TEXT NOT NULL
    )
  ''';

  // status yang valid: 'pending' | 'synced' | 'failed'
}
