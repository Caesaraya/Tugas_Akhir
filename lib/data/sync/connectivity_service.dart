// lib/data/sync/connectivity_service.dart
//
// Hanya bertanggung jawab mendeteksi transisi offline -> online dan memicu
// SyncManager.runSync(). Tidak tahu apa-apa soal isi sync_queue.

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'sync_manager.dart';

class ConnectivityService {
  ConnectivityService._internal();
  static final ConnectivityService instance = ConnectivityService._internal();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _wasOffline = false;

  Future<bool> get isOnline async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  void start() {
    _subscription?.cancel();
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final online = !results.contains(ConnectivityResult.none);

      if (online && _wasOffline) {
        // Baru saja kembali online -> jalankan sync.
        SyncManager.instance.runSync();
      }
      _wasOffline = !online;
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}
