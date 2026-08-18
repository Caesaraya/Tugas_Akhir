import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/provider/midtrans_providers.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/services/payment_service.dart';

class BuyController extends GetxController {
  final MidtransProvider midtransProvider = MidtransProvider();
  final PaymentService paymentService = PaymentService();

  var isPaying = false.obs;

  Future<void> checkout({
    required String title,
    required int amount,
     bool isDesktop = false,
  }) async {
    try {
      isPaying.value = true;

      final result = await midtransProvider.fetchSnapToken(
        title: title,
        amount: amount,
      );

      if (result == null) {
        isPaying.value = false;
        Get.snackbar("Error", "Gagal mendapatkan Snap Token");
        return;
      }

      final snapToken = result['token']!;
      final orderId = result['order_id']!;

      // Buka browser — TIDAK await, biarkan polling jalan di background
      paymentService.startPayment(
        snapToken,
        orderId,
        onSuccess: () {
          isPaying.value = false;
          final isDesktop = !kIsWeb &&
              (Platform.isWindows || Platform.isMacOS || Platform.isLinux);
          if (isDesktop) {
            Get.offAllNamed(AppRoutes.kasirprint);
          } else {
            Get.offAllNamed(AppRoutes.sukses);
          }
        },
        onPending: () {
          isPaying.value = false;
          Get.snackbar(
            "Pembayaran",
            "Pembayaran belum selesai atau dibatalkan",
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );

      // Jangan await dan jangan finally — biarkan polling jalan
    } catch (e) {
      isPaying.value = false;
      Get.snackbar("Payment Error", e.toString());
    }
  }
}