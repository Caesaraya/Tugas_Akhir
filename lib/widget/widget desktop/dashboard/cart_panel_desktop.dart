import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../../controller/mobile/cart_controller.dart';
import '../../widget mobile/cart_item.dart';
import 'package:intl/intl.dart'; // 1. Tambahkan import ini

class CartPanelDesktop extends StatelessWidget {
  const CartPanelDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    // 2. Tambahkan formatter di dalam build
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
          /// KASIR
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

          /// KERANJANG
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
              } else {
              return ListView.builder(
  padding: const EdgeInsets.all(12),
  itemCount: cartController.cartItems.length,
  itemBuilder: (context, index) {
    final item = cartController.cartItems[index];
    return CartTile(
      item: item,
      onAdd: () => cartController.increaseQty(item.productId),
      
      // PERBAIKAN: Tambahkan logika if (item.qty > 1)
      onRemove: () {
        if (item.qty > 1) {
          cartController.decreaseQty(item.productId);
        }
      },
      
      onDelete: () => cartController.removeFromCart(item.productId),
    );
  },
);
              }
            }),
          ),

          /// FOOTER BAYAR
          Obx(
            () => Container(
              padding: const EdgeInsets.all(16),
              color: cartController.cartItems.isNotEmpty
                  ? Colors.orange
                  : Colors.grey[200],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: cartController.cartItems.isNotEmpty
                        ? () => Get.toNamed(AppRoutes.kasirbayar)
                        : null,
                    child: Text(
                      "${cartController.itemCount} | Bayar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, // Tambahkan bold agar lebih jelas
                        color: cartController.cartItems.isNotEmpty
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  // 3. Gunakan currencyFormat di sini
                  Text(
                    currencyFormat.format(cartController.totalPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: cartController.cartItems.isNotEmpty
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}