import 'package:get/get.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class RiwayatController extends GetxController {
  var transactions = [].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

 
  void fetchHistory() async {
    try {
      isLoading(true);
      var data = await ApiService.getTransactions();
  
      var details = await Future.wait(
        data.map(
          (trx) =>
              ApiService.getTransactionDetail(int.parse(trx['id'].toString())),
        ),
      );
     
      for (int i = 0; i < data.length; i++) {
        if (details[i]['items'] != null) {
          data[i]['items'] = details[i]['items'];
        } else {
          data[i]['items'] = [];
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