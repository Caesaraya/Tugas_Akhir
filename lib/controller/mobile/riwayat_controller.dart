import 'package:get/get.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/routes/routes.dart';

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
      var rawData = await ApiService.getTransactions();
      
      // KUNCI PERBAIKAN: Paksa data menjadi List<Map> yang bisa diubah (mutable)
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        rawData.map((x) => Map<String, dynamic>.from(x))
      );

      var details = await Future.wait(
        data.map((trx) => ApiService.getTransactionDetail(int.parse(trx['id'].toString()))),
      );

      for (int i = 0; i < data.length; i++) {
        dynamic currentDetail = details[i];
        
        if (currentDetail is Map) {
          // Gunakan pengecekan key yang aman
          if (currentDetail.containsKey('items')) {
            data[i]['items'] = currentDetail['items'];
          } else if (currentDetail.containsKey('data')) {
            data[i]['items'] = currentDetail['data'];
          } else {
            // Jika Map tidak punya key pembungkus, bungkus sendiri jadi List
            data[i]['items'] = [currentDetail];
          }
        } else if (currentDetail is List) {
          data[i]['items'] = currentDetail;
        } else {
          data[i]['items'] = [];
        }
      }

      transactions.assignAll(data);
    } catch (e) {
      print("Error Riwayat: $e");
      Get.snackbar("Error", "Gagal memproses data: $e");
    } finally {
      isLoading(false);
    }
  }
  // Di dalam class RiwayatController
void goToDetail(dynamic trx) {
  Get.toNamed(
    AppRoutes.sukses,
    arguments: {
      'total': trx['total_harga'],
      'bayar': trx['jumlah_bayar'],
      'kembalian': trx['kembalian'],
      'metode': trx['metode_pembayaran'],
      'items': trx['items'],
      'isFromHistory': 'true', // Kirim sebagai string agar konsisten dengan pengecekan di SuksesPage
    },
  );
}

// Tambahkan juga fungsi helper untuk format tanggal di controller agar UI lebih bersih
String formatTransactionDate(String dateString) {
  try {
    DateTime dt = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy, HH:mm').format(dt);
  } catch (e) {
    return dateString;
  }
}
}