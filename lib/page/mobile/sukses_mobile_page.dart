import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/page/mobile/navbar_page.dart';
import 'package:tugas_akhir/widget/widget mobile/success_widgets.dart';

class SuksesMobilePage extends StatelessWidget {
  final CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuccessHeader(),
            const SizedBox(height: 40),
            InfoRow(
              label: "Total Tagihan",
              value: "Rp ${controller.totalPrice.toInt()}",
            ),
            InfoRow(
              label: controller.paymentMethodLabel, 
              value: controller.paymentDisplayValue,
            ),
            const Divider(thickness: 1.5, height: 30),
            InfoRow(
              label: "Kembalian",
              value: controller.kembalianDisplay,
              isBold: true,
            ),
            const SizedBox(height: 50),
            SuccessActions(
              onPrint: () => print("Proses Print..."),
              onFinish: () {
                Get.offAll(() => NavbarPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}