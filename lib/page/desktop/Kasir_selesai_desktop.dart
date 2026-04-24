import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/cart_controller.dart';
import '../../controller/payment_controller.dart';
import '../../widget/widget desktop/dashboard/app_bar_desktop.dart';
import '../../widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import '../../widget/widget desktop/dashboard/komponen_nota.dart';

class KasirSelesaiDesktop extends StatelessWidget {
  const KasirSelesaiDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final PaymentController paymentController = Get.find<PaymentController>();

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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: const Offset(0, 6),
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
                                      unitPrice: item.price - item.discount,
                                      totalPrice:
                                          item.qty *
                                          (item.price - item.discount),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    Obx(
                      () => ReceiptRowItem(
                        title: "Total Tagihan",
                        value:
                            "Rp ${cartController.totalPrice.toStringAsFixed(0)}",
                      ),
                    ),
                    const SizedBox(height: 12),

                    const SizedBox(height: 12),
                    Obx(
                      () => ReceiptRowItem(
                        title: "Jumlah Dibayar",
                        value: paymentController.input.value.isEmpty
                            ? "Rp 0"
                            : "Rp ${paymentController.input.value}",
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => ReceiptRowItem(
                        title: "Kembalian",
                        value: paymentController.input.value.isEmpty
                            ? "Rp 0"
                            : "Rp ${_calculateChange(cartController.totalPrice, paymentController.input.value)}",
                      ),
                    ),
                    Obx(
                      () => ReceiptRowItem(
                        title: "Metode Pembayaran",
                        value: paymentController.selectedMethod.value.isEmpty
                            ? "-"
                            : paymentController.selectedMethod.value,
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
                            // Simpan transaksi ke API
                            await cartController.prosesKeApi();
                            // Bersihkan keranjang setelah simpan
                            cartController.clearCart();
                            // Navigasi kembali ke dashboard
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

  static String _calculateChange(double totalPrice, String input) {
    final paid = double.tryParse(input.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final change = paid - totalPrice;
    return change > 0 ? change.toStringAsFixed(0) : '0';
  }
}
