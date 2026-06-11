import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../api service/api_service.dart';
import '../../models/transactions.dart';
import '../../models/keuangan_summary.dart';
import '../../models/histori_stok.dart';

class KeuanganController extends GetxController {
  final isLoading = false.obs;
  final keuangan = KeuanganSummary.kosong().obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadDataKeuangan();
  }

  Future<void> loadDataKeuangan() async {
    try {
      isLoading(true);

      // 1. HITUNG PEMASUKAN DARI API TRANSAKSI BACKEND
      final response = await ApiService.getTransactions();
      List<dynamic> rawListData = [];
      if (response is List) {
        rawListData = response;
      } else if (response is Map) {
        final responseMap = response as Map<String, dynamic>;
        if (responseMap['data'] is List) rawListData = responseMap['data'];
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

      // 2. HITUNG PENGELUARAN DARI LOCAL EVENT TRACKER STORAGE
      double totalPengeluaran = 0;
      List<dynamic> localData = _storage.read('histori_pengeluaran') ?? [];

      final listHistori = localData
          .map<HistoriStokModel>((e) => HistoriStokModel.fromJson(e))
          .toList();

      for (final histori in listHistori) {
        // Filter pengeluaran yang terjadi hanya di bulan dan tahun berjalan saat ini
        if (histori.tanggal.month == sekarang.month &&
            histori.tanggal.year == sekarang.year) {
          totalPengeluaran += histori.totalPengeluaran;
        }
      }

      // 3. HITUNG PROFIT BERSIH (Pemasukan - Pengeluaran)
      double totalProfit = totalPemasukan - totalPengeluaran;

      keuangan.value = KeuanganSummary(
        pemasukan: totalPemasukan,
        pengeluaran: totalPengeluaran,
        profit: totalProfit,
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
