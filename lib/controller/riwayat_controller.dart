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
      transactions.assignAll(data); 
    } catch (e) {
      Get.snackbar("Error", "Gagal ambil riwayat: $e");
    } finally {
      isLoading(false);
    }
  }
}