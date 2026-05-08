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
      var data = await ApiService.getTransactions();

      // Gunakan dynamic untuk menampung hasil yang fleksibel
      var details = await Future.wait(
        data.map<Future<dynamic>>(
          (trx) => ApiService.getTransactionDetail(int.parse(trx['id'].toString())),
        ),
      );

      for (int i = 0; i < data.length; i++) {
        var currentDetail = details[i];
        
        // Pengecekan: Apakah detail berupa Map yang berisi key 'items' atau langsung List?
        if (currentDetail is Map && currentDetail.containsKey('items')) {
          data[i]['items'] = currentDetail['items'];
        } else if (currentDetail is List) {
          data[i]['items'] = currentDetail;
        } else {
          data[i]['items'] = []; // Fallback jika data kosong atau format salah
        }
      }

      transactions.assignAll(data);
    } catch (e) {
      // ignore: avoid_print
      print("Error Detail: $e"); // Cek log untuk melihat detail error sebenarnya
      Get.snackbar("Error", "Gagal ambil riwayat: $e");
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