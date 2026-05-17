import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class RiwayatController extends GetxController {
  var transactions = [].obs;
  var isLoading = true.obs;
  var isLoadingDetail = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void fetchHistory() async {
    try {
      isLoading(true);
      var data = await ApiService.getTransactions();
      for (var trx in data) {
        trx['items'] = [];
      }
      transactions.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal ambil riwayat: $e");
    } finally {
      isLoading(false);
    }
  }


Future<void> fetchDetail(int id) async {
  try {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final detail = await ApiService.getTransactionDetail(id);
    final index = transactions.indexWhere(
      (t) => int.parse(t['id'].toString()) == id,
    );
    if (index != -1) {
      transactions[index]['items'] = detail['items'] ?? [];
      transactions.refresh();
    }
  } catch (e) {
    Get.snackbar("Error", "Gagal ambil detail: $e");
  } finally {
    if (Get.isDialogOpen ?? false) Get.back(); // tutup loading
  }
}
Future<void> navigateToDetail(Map<String, dynamic> trx, String route) async {
    final id = int.parse(trx['id'].toString());
    await fetchDetail(id);
    final updatedTrx = transactions.firstWhere(
      (t) => int.parse(t['id'].toString()) == id,
      orElse: () => trx,
    );
    Get.toNamed(route, arguments: {
      'id': updatedTrx['id'],
      'tanggal': updatedTrx['tanggal'],
      'total_harga': updatedTrx['total_harga'],
      'jumlah_bayar': updatedTrx['jumlah_bayar'],
      'kembalian': updatedTrx['kembalian'],
      'metode_pembayaran': updatedTrx['metode_pembayaran'],
      'items': updatedTrx['items'],
    });
  }
}