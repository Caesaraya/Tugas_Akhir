import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/payment_controller.dart';
import '../../controller/cart_controller.dart';
import '../../widget/widget desktop/bayar/payment_method_widget.dart';
import '../../widget/widget desktop/bayar/quick_chip.dart';
import '../../widget/widget desktop/bayar/calculator_keypad.dart';

class KasirPembayaranDesktop extends StatelessWidget {
  const KasirPembayaranDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(PaymentController());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const PaymentPage(),
    );
  }
}

class PaymentPage extends StatelessWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());
    final CartController cartController = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembayaran"),
        backgroundColor: Colors.orange,
      ),
      body: Row(
        children: [
          /// LEFT PANEL
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Tagihan"),
                  const SizedBox(height: 5),
                  Obx(
                    () => Text(
                      "Rp ${cartController.totalPrice.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text("Metode Pembayaran"),
                  Obx(
                    () => PaymentMethodWidget(
                      title: "Cash",
                      selectedMethod: controller.selectedMethod.value,
                      onChanged: controller.onPaymentMethodChanged,
                    ),
                  ),
                  Obx(
                    () => PaymentMethodWidget(
                      title: "E-wallet/Qris",
                      selectedMethod: controller.selectedMethod.value,
                      onChanged: controller.onPaymentMethodChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// RIGHT PANEL
          Expanded(
            flex: 3,
            child: Column(
              children: [
                /// Quick buttons
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      QuickChip(
                        text: "Uang Pas",
                        onPressed: () => controller.onChipPressed(
                          "Uang Pas",
                          totalPrice: cartController.totalPrice,
                        ),
                      ),
                      QuickChip(
                        text: "Rp50,000",
                        onPressed: () => controller.onChipPressed("Rp60,000"),
                      ),
                      QuickChip(
                        text: "Rp100,000",
                        onPressed: () => controller.onChipPressed("Rp100,000"),
                      ),
                    ],
                  ),
                ),

                /// Input display
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => Text(
                        controller.input.value.isEmpty
                            ? "Rp 0"
                            : "Rp ${controller.input.value}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                /// Keypad
                CalculatorKeypad(onButtonPressed: controller.onButtonPressed),

                /// Pay Button
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.kasirprint);
                    },
                    child: const Text(
                      "Bayar",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
