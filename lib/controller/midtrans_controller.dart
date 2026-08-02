import 'package:get/get.dart';
import 'package:tugas_akhir/provider/midtrans_providers.dart';
import '../services/payment_service.dart';

class BuyController extends GetxController {
  final MidtransProvider midtransProvider = MidtransProvider();
  final PaymentService paymentService = PaymentService();

  var isPaying = false.obs;

  Future<void> checkout({
    required String title,
    required int amount,
  }) async {
    try {
      isPaying.value = true;

      final snapToken = await midtransProvider.fetchSnapToken(
        title: title,
        amount: amount,
      );

      if (snapToken == null) {
        Get.snackbar("Error", "Gagal mendapatkan Snap Token");
        return;
      }

      await paymentService.startPayment(snapToken);
    } catch (e) {
      Get.snackbar("Payment Error", e.toString());
    } finally {
      isPaying.value = false;
    }
  }
}