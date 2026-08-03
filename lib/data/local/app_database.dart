import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'tables/product_table.dart';
import 'tables/transaction_table.dart';
import 'tables/transaction_detail_table.dart';
import 'tables/cart_table.dart';
import 'tables/sync_queue_table.dart';

class AppDatabase {
  AppDatabase._internal();
  static final AppDatabase instance = AppDatabase._internal();

  static const String _dbName = 'tugas_akhir_offline.db';
  static const int _dbVersion = 2;

  static bool _sqliteInitialized = false;

  static void _ensureDatabaseFactoryInitialized() {
    if (_sqliteInitialized) return;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    _sqliteInitialized = true;
  }

  Database? _db;

  Future<Database> get database async {
    _ensureDatabaseFactoryInitialized();
    if (_db != null) return _db!;
    _db = await _open();
    return _db!;
  }

  Future<Database> _open() async {
    _ensureDatabaseFactoryInitialized();
    final path = join(await getDatabasesPath(), _dbName);

    print("================================");
    print("DATABASE PATH: $path");
    print("================================");

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute(ProductTable.createTableQuery);
        await db.execute(TransactionTable.createTableQuery);
        await db.execute(TransactionDetailTable.createTableQuery);
        await db.execute(CartTable.createTableQuery);
        await db.execute(SyncQueueTable.createTableQuery);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE ${CartTable.tableName} ADD COLUMN stock INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
    );
  }
}
