import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/payment_method.dart';
import 'package:tugas_akhir/page/mobile/sukses_mobile_page.dart';
import 'package:tugas_akhir/page/mobile/kalkulator_mobile.dart';

class KeranjangMobilePage extends StatelessWidget {
  // Gunakan find agar data tetap konsisten dari halaman sebelumnya
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Keranjang",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
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
            // List Item Produk
            ListView.builder(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: 180,
              ),
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                var item = cartController.cartItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "${item.qty} X  |  ",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                // Tampilkan harga bersih (sudah diskon)
                                Text(
                                  "Rp ${(item.price - item.discount).toInt()}",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Tombol Aksi
                      Row(
                        children: [
                          // Tombol Minus (Warna abu-abu jika qty=1)
                          IconButton(
                            onPressed: item.qty > 1
                                ? () =>
                                      cartController.decreaseQty(item.productId)
                                : null,
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: item.qty > 1
                                  ? Colors.orange
                                  : Colors.grey.shade400,
                              size: 28,
                            ),
                          ),
                          Text(
                            "${item.qty}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                cartController.increaseQty(item.productId),
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.orange,
                              size: 28,
                            ),
                          ),
                          // Tombol Hapus (Satu-satunya cara untuk membuang item qty 1)
                          IconButton(
                            onPressed: () =>
                                cartController.removeFromCart(item.productId),
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.brown,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            // Panel Rincian Harga & Tombol Bayar
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Rincian Subtotal
                    PaymentMethodSection(),

                    const SizedBox(height: 16),
                    const Divider(thickness: 1),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Subtotal",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Text(
                          "Rp ${cartController.subtotal.toInt()}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Tanda Potongan Diskon (Hanya muncul jika hemat > 0)
                    if (cartController.totalDiscount > 0)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Potongan Diskon",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "- Rp ${cartController.totalDiscount.toInt()}",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(thickness: 1),
                    ),

                    // Total Akhir
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Pesanan:",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Rp ${cartController.totalPrice.toInt()}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Tombol Bayar
                    // Tombol Bayar
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          // LOGIKA PERCABANGAN DISINI
                          if (cartController.selectedPayment.value == 'cash') {
                            // Jika pilih Cash, arahkan ke Kalkulator
                            Get.to(() => KalkulatorCashPage());
                          } else {
                            // Jika pilih selain Cash (QRIS/VA), langsung ke halaman sukses
                            Get.offAll(() => SuksesMobilePage());
                          }
                        },
                        child: const Text(
                          "Bayar Sekarang",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
