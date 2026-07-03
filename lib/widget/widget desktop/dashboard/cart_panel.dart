import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/controller/payment_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/keranjang/item_card.dart';
import 'package:intl/intl.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final PaymentController paymentController = Get.find<PaymentController>();
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      width: 320,
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          // ✅ Header user
          Container(
            padding: const EdgeInsets.all(12),
            child: const Row(
              children: [
                Icon(Icons.account_circle),
                SizedBox(width: 8),
                Text("Somar - Kasir 1"),
              ],
            ),
          ),
          const Divider(),

          // ✅ List item — pakai KeranjangItemCard sama seperti mobile
          Expanded(
            child: Obx(() {
              if (cartController.cartItems.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, size: 70, color: Colors.grey),
                      SizedBox(height: 10),
                      Text("Keranjang Kosong", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return KeranjangItemCard(ctrl: paymentController, item: item);
                },
              );
            }),
          ),

          // ✅ Tombol bayar — tetap sama seperti desktop
          Obx(() {
            final bool hasItems = cartController.cartItems.isNotEmpty;
            return InkWell(
              onTap: hasItems ? () => Get.toNamed(AppRoutes.kasirbayar) : null,
              child: Container(
                padding: const EdgeInsets.all(16),
                color: hasItems ? Colors.orange : Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${cartController.itemCount} | Bayar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: hasItems ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      currencyFormat.format(cartController.totalPrice),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: hasItems ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
