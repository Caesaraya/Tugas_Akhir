import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/page/mobile/navbar_page.dart';
import 'package:tugas_akhir/widget/widget mobile/success_widgets.dart';

class SuksesMobilePage extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    // 1. Tentukan label metode pembayaran
    String methodLabel = cartController.selectedPayment.value == "va"
        ? "Virtual Account"
        : (cartController.selectedPayment.value == "qris"
              ? "QRIS"
              : "Tunai / Cash");

    // 2. Tentukan nilai yang ditampilkan untuk baris metode pembayaran
    // Jika Cash, tampilkan inputUang. Jika VA/QRIS, tampilkan totalPrice (karena uang pas)
    String paymentValue = cartController.selectedPayment.value == "cash"
        ? "Rp ${cartController.inputUang.value.toInt()}"
        : "Rp ${cartController.totalPrice.toInt()}";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuccessHeader(),
            const SizedBox(height: 40),

            // Menampilkan Total Tagihan (Harga asli)
            InfoRow(
              label: "Total Tagihan",
              value: "Rp ${cartController.totalPrice.toInt()}",
            ),

            // Menampilkan Nominal yang Dibayarkan (Tunai/VA/QRIS)
            InfoRow(label: methodLabel, value: paymentValue),

            const Divider(thickness: 1.5, height: 30),

            // Menampilkan Kembalian secara dinamis dari controller
            InfoRow(
              label: "Kembalian",
              value: cartController.selectedPayment.value == "cash"
                  ? "Rp ${cartController.kembalian.toInt()}"
                  : "Rp 0",
              isBold: true,
            ),

            const SizedBox(height: 50),

            SuccessActions(
              onPrint: () => print("Proses Print..."),
              onFinish: () {
                cartController.clearCart();
                Get.offAll(() => NavbarPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}
