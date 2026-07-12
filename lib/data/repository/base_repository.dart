// lib/data/repository/base_repository.dart
//
// Semua Repository (Product, Transaction, dan nanti BahanBaku/Resep/dll)
// extend class ini agar punya akses db yang seragam dan satu cara untuk
// mendaftarkan perubahan ke sync_queue. Ini bagian dari kontrak yang bikin
// SyncManager tidak perlu tahu detail tiap modul.

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../local/app_database.dart';
import '../local/tables/sync_queue_table.dart';

abstract class BaseRepository {
  Future<Database> get db => AppDatabase.instance.database;

  /// Mendaftarkan satu perubahan (INSERT/UPDATE/DELETE) ke sync_queue.
  /// [entityId] pakai localId (String) supaya konsisten walau entity
  /// menggunakan int id di server (mis. Product tetap boleh pakai
  /// id.toString() sebagai entityId).
  Future<void> enqueueSync({
    required String entityType,
    required String entityId,
    required String operation,
    required Map<String, dynamic> payload,
  }) async {
    final database = await db;
    final now = DateTime.now().toIso8601String();

    await database.insert(SyncQueueTable.tableName, {
      'entity_type': entityType,
      'entity_id': entityId,
      'operation': operation,
      'payload': jsonEncode(payload),
      'status': 'pending',
      'retry_count': 0,
      'created_at': now,
      'updated_at': now,
    });
  }
}
