import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class RiwayatController extends GetxController {
  var transactions = [].obs;
  var isLoading = true.obs;
  var isLoadingDetail = false.obs; // ✅ loading per item

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  // ✅ Hanya fetch list — 1 request saja
  void fetchHistory() async {
    try {
      isLoading(true);
      var data = await ApiService.getTransactions();
      // Setiap item langsung punya items kosong dulu
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

  // ✅ Fetch detail hanya saat user tap 1 item
Future<void> fetchDetail(int id) async {
  try {
    // Tampilkan loading dialog
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
}