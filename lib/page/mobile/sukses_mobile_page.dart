import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/success_widgets.dart';

class SuksesMobilePage extends StatelessWidget {
  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final data = controller.getSuksesData(Get.arguments);
    final bool isFromHistory = data['isHistory'] == 'true';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Nota Transaksi",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => controller.handleSelesaiAction(isFromHistory),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuccessHeader(),
            const SizedBox(height: 40),
            InfoRow(label: "Total Tagihan", value: data['total']!),
            InfoRow(label: data['label']!, value: data['bayar']!),
            const Divider(thickness: 1.5, height: 30),
            InfoRow(
              label: "Kembalian",
              value: data['kembalian']!,
              isBold: true,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
