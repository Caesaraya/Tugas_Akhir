import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/controller/payment_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/keranjang/bottom_panel.dart';
import 'package:tugas_akhir/widget/widget%20mobile/keranjang/item_card.dart';
 

class KeranjangMobilePage extends StatelessWidget {
  const KeranjangMobilePage({super.key});
 
  @override
  Widget build(BuildContext context) {
    Get.find<CartController>();
    final ctrl = Get.put(PaymentController());
 
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Keranjang',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (ctrl.cartController.cartItems.isEmpty) {
          return const Center(
            child: Text('Belum ada produk di keranjang'),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                itemCount: ctrl.cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = ctrl.cartController.cartItems[index];
                  return KeranjangItemCard(ctrl: ctrl, item: item);
                },
              ),
            ),
            KeranjangBottomPanel(ctrl: ctrl),
          ],
        );
      }),
    );
  }
}