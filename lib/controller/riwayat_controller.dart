import 'package:get/get.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class RiwayatController extends GetxController {
  var transactions = [].obs; // Menampung list dari API
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory(); // Ambil data pas aplikasi dibuka
  }

  // Fungsi ambil data dari database via API
  void fetchHistory() async {
    try {
      isLoading(true);
      var data = await ApiService.getTransactions();
      // Ambil detail untuk setiap transaksi
      var details = await Future.wait(
        data.map(
          (trx) =>
              ApiService.getTransactionDetail(int.parse(trx['id'].toString())),
        ),
      );
      // Assign items ke setiap transaksi
      for (int i = 0; i < data.length; i++) {
        if (details[i]['items'] != null) {
          data[i]['items'] = details[i]['items'];
        } else {
          data[i]['items'] = []; // Default empty list jika tidak ada items
        }
      }
      transactions.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Gagal ambil riwayat: $e");
    } finally {
      isLoading(false);
    }
  }
}