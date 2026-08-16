// lib/controller/riwayat_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/data/repository/transaction_repository.dart';

class RiwayatController extends GetxController {
  var transactions = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var isLoadingDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  /// Membaca riwayat transaksi dari SQLite lokal (Single Source of Truth)
  void fetchHistory() async {
    try {
      isLoading(true);

      var data = await TransactionRepository.instance.getAllLocalWithDetails();

      transactions.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal ambil riwayat lokal: $e");
    } finally {
      isLoading(false);
    }
  }

  /// Pertahankan fungsi agar tidak error jika ada widget yang memanggilnya
  Future<void> fetchDetail(dynamic id) async {
    return;
  }

  /// Navigasi ke halaman detail tanpa konversi int.parse() dan tanpa network request
  Future<void> navigateToDetail(Map<String, dynamic> trx, String route) async {
    final updatedTrx = transactions.firstWhere(
      (t) => t['id']?.toString() == trx['id']?.toString(),
      orElse: () => trx,
    );

    Get.toNamed(
      route,
      arguments: {
        'id': updatedTrx['id'] ?? updatedTrx['local_id'],
        'tanggal': updatedTrx['tanggal'],
        'total_harga': updatedTrx['total_harga'],
        'jumlah_bayar': updatedTrx['jumlah_bayar'],
        'kembalian': updatedTrx['kembalian'],
        'metode_pembayaran': updatedTrx['metode_pembayaran'],
        'items': updatedTrx['items'] ?? [],
      },
    );
  }
}
