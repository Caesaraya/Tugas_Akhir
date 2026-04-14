import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/cart_controller.dart';
import '../../controller/payment_controller.dart';

class KasirSelesaiDesktop extends StatelessWidget {
  const KasirSelesaiDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final PaymentController paymentController = Get.find<PaymentController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                  child: const Icon(Icons.check, color: Colors.white, size: 32),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Obx(
                () => cartController.cartItems.isEmpty
                    ? const Text("Tidak ada produk yang dibeli.")
                    : Column(
                        children: cartController.cartItems
                            .map(
                              (item) => _productRow(
                                item.name,
                                item.qty,
                                item.price - item.discount,
                                item.qty * (item.price - item.discount),
                              ),
                            )
                            .toList(),
                      ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              Obx(
                () => _rowItem(
                  "Total Tagihan",
                  "Rp ${cartController.totalPrice.toStringAsFixed(0)}",
                ),
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 12),
              Obx(
                () => _rowItem(
                  "Jumlah Dibayar",
                  paymentController.input.value.isEmpty
                      ? "Rp 0"
                      : "Rp ${paymentController.input.value}",
                ),
              ),
              const SizedBox(height: 12),
              Obx(
                () => _rowItem(
                  "Kembalian",
                  paymentController.input.value.isEmpty
                      ? "Rp 0"
                      : "Rp ${_calculateChange(cartController.totalPrice, paymentController.input.value)}",
                ),
              ),
              Obx(
                () => _rowItem(
                  "Metode Pembayaran",
                  paymentController.selectedMethod.value.isEmpty
                      ? "-"
                      : paymentController.selectedMethod.value,
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Print Nota",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.kasirboarddesk);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Selesai"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _rowItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  static Widget _productRow(
    String name,
    int qty,
    double unitPrice,
    double totalPrice,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name, style: const TextStyle(fontSize: 14))),
          Text("x$qty", style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 12),
          Text(
            "Rp ${totalPrice.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
