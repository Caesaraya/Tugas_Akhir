import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/mobile/payment_controller.dart';
import '../../controller/mobile/cart_controller.dart';
import '../../widget/widget desktop/bayar/payment_method_widget.dart';
import '../../widget/widget desktop/bayar/calculator_keypad.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatelessWidget {
  PaymentPage({super.key});

  

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
     final PaymentController controller = Get.put(PaymentController());
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

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
                      // 2. Gunakan currencyFormat di sini
                      currencyFormat.format(cartController.totalPrice),
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
                      value: "cash",
                      selectedMethod: controller.selectedMethod.value,
                      onChanged: controller.onPaymentMethodChanged,
                    ),
                  ),
                  Obx(
                    () => PaymentMethodWidget(
                      title: "QRIS",
                      value: "qris",
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
                  child: Row(children: []),
                ),

                /// Input display
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Obx(() {
                      int amount = int.tryParse(controller.input.value) ?? 0;

                      return Text(
                        currencyFormat.format(amount),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
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
                      cartController.selectedPayment.value =
                          controller.selectedMethod.value;
                      cartController.inputUang.value =
                          double.tryParse(
                            controller.input.value.replaceAll(
                              RegExp(r'[^0-9]'),
                              '',
                            ),
                          ) ??
                          0;
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
