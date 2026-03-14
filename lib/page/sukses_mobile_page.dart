import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/page/navbar_page.dart';
import 'package:tugas_akhir/widget/success_widgets.dart';


class SuksesMobilePage extends StatelessWidget {
  final CartController cartController = Get.find();

  @override
  Widget build(BuildContext context) {
    // Logika penentuan label tetap di sini (sebagai pengelola data)
    String methodLabel = cartController.selectedPayment.value == "va" 
        ? "Virtual Account" 
        : (cartController.selectedPayment.value == "qris" ? "QRIS" : "Tunai / Cash");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuccessHeader(), // Widget Header
            const SizedBox(height: 40),

            // Rincian Pembayaran menggunakan widget InfoRow
            InfoRow(label: "Total Tagihan", value: "Rp ${cartController.totalPrice.toInt()}"),
            InfoRow(label: methodLabel, value: "Rp ${cartController.totalPrice.toInt()}"),
            
            const Divider(thickness: 1.5, height: 30),
            
            InfoRow(label: "Kembalian", value: "Rp 0", isBold: true),
            const SizedBox(height: 50),

            // Widget Tombol Aksi
            SuccessActions(
              onPrint: () => print("Proses Print..."),
              onFinish: () {
                cartController.clearCart();
              Get.to(() => NavbarPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}