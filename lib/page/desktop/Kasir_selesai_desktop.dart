import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/mobile/cart_controller.dart';
import '../../controller/mobile/payment_controller.dart';
import '../../widget/widget desktop/dashboard/app_bar_desktop.dart';
import '../../widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import '../../widget/widget desktop/dashboard/komponen_nota.dart';
import 'package:intl/intl.dart'; // Pastikan ini ada

class KasirSelesaiDesktop extends StatelessWidget {
  const KasirSelesaiDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final PaymentController paymentController = Get.find<PaymentController>();

    // 1. Tambahkan formatter untuk format ribuan
    final formatter = NumberFormat.decimalPattern('id');

    return Scaffold(
      drawer: const DesktopNavigationDrawer(currentRoute: AppRoutes.kasirprint),
      body: Column(
        children: [
          const AppBarDesktop(title: 'Transaksi Selesai', showSearch: false),
          Expanded(
            child: Center(
              child: Container(
                width: 520,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0, 6),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        "Sukses!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Detail Pembelian",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => cartController.cartItems.isEmpty
                          ? const Text("Tidak ada produk yang dibeli.")
                          : Column(
                              children: cartController.cartItems
                                  .map(
                                    (item) => ReceiptProductRow(
                                      name: item.name,
                                      qty: item.qty,
                                      // Menggunakan formatter untuk unitPrice
                                      unitPrice: (item.price - item.discount).toDouble(),
                                      totalPrice: item.qty.toDouble() * (item.price - item.discount).toDouble(),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Update bagian nominal di bawah ini
                    Obx(
                      () => ReceiptRowItem(
                        title: "Total Tagihan",
                        value: "Rp ${formatter.format(cartController.totalPrice)}",
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () {
                        final paid = double.tryParse(paymentController.input.value) ?? 0;
                        return ReceiptRowItem(
                          title: "Jumlah Dibayar",
                          value: "Rp ${formatter.format(paid)}",
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () {
                        final change = _calculateChangeValue(cartController.totalPrice, paymentController.input.value);
                        return ReceiptRowItem(
                          title: "Kembalian",
                          value: "Rp ${formatter.format(change)}",
                        );
                      },
                    ),
                    Obx(
                      () => ReceiptRowItem(
                        title: "Metode Pembayaran",
                        value: paymentController.methodLabel,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        ReceiptActionButton(
                          label: "Print Nota",
                          onPressed: () {},
                          backgroundColor: Colors.grey[400]!,
                          textColor: Colors.black,
                        ),
                        const SizedBox(width: 16),
                        ReceiptActionButton(
                          label: "Selesai",
                          onPressed: () async {
                            await cartController.prosesKeApi();
                            cartController.clearCart();
                            Get.offAllNamed(AppRoutes.kasirboarddesk);
                          },
                          backgroundColor: Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi pembantu baru untuk mendapatkan nilai double kembalian
  static double _calculateChangeValue(double totalPrice, String input) {
    final paid = double.tryParse(input.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final change = paid - totalPrice;
    return change > 0 ? change : 0;
  }
}