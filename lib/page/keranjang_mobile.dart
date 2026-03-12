import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';

class KeranjangMobilePage extends StatelessWidget {
  // Mencari controller yang sudah aktif
  final CartController cartController = Get.put<CartController>(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Keranjang", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return const Center(child: Text("Belum ada roti di keranjang"));
        }

        return Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                var item = cartController.cartItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade400, width: 1.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      // Detail Roti
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("${item.qty} X  |  Rp ${item.price.toInt()}", style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      // Tombol Aksi (Sesuai gambar kamu)
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => cartController.decreaseQty(item.productId),
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.orange, size: 30),
                          ),
                          IconButton(
                            onPressed: () => cartController.increaseQty(item.productId),
                            icon: const Icon(Icons.add_circle_outline, color: Colors.orange, size: 30),
                          ),
                          IconButton(
                            onPressed: () => cartController.removeFromCart(item.productId),
                            icon: const Icon(Icons.delete_outline, color: Colors.brown, size: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            // Bagian Bawah: Total & Bayar
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total Pesanan:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        Text("Rp ${cartController.totalPrice.toInt()}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade900,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          // Logika pembayaran Midtrans bisa ditaruh di sini nanti
                        },
                        child: const Text("Bayar", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}