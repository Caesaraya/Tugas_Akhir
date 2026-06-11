import 'package:get/get.dart';

import '../../api service/api_service.dart';
import '../../models/transactions.dart';
import '../../models/keuangan_summary.dart';

class KeuanganController extends GetxController {
  final isLoading = false.obs;

  final keuangan = KeuanganSummary.kosong().obs;

  @override
  void onInit() {
    super.onInit();
    loadDataKeuangan();
  }

  Future<void> loadDataKeuangan() async {
    try {
      isLoading(true);

      final response = await ApiService.getTransactions();

      // Penanganan defensif untuk variasi format JSON dari Backend
      // Penanganan defensif untuk variasi format JSON dari Backend
      List<dynamic> rawListData = [];
      if (response is List) {
        rawListData = response;
      } else if (response is Map) {
        // Cast response menjadi Map agar bisa diakses menggunakan Key String
        final responseMap = response as Map<String, dynamic>;

        if (responseMap['data'] is List) {
          rawListData = responseMap['data'];
        } else if (responseMap['transactions'] is List) {
          rawListData = responseMap['transactions'];
        }
      }

      final transaksi = rawListData
          .map<TransactionModel>((e) => TransactionModel.fromJson(e))
          .toList();

      final sekarang = DateTime.now();

      double totalPemasukan = 0;

      for (final trx in transaksi) {
        final tanggal = DateTime.tryParse(trx.tanggal);

        if (tanggal == null) continue;

        if (tanggal.month == sekarang.month && tanggal.year == sekarang.year) {
          totalPemasukan += trx.totalHarga;
        }
      }

      keuangan.value = KeuanganSummary(
        pemasukan: totalPemasukan,
        pengeluaran: 0,
        profit: totalPemasukan,
      );
    } catch (e) {
      print('Error loadDataKeuangan: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshData() async {
    await loadDataKeuangan();
  }
}
