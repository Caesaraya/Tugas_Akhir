import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/desktop/payment_dashboard_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/bayar/payment_method_widget.dart';
import 'package:tugas_akhir/widget/widget desktop/bayar/calculator_keypad.dart';

class KasirPembayaranDesktop extends StatelessWidget {
  const KasirPembayaranDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentDashboardController paymentDashboardController =
        Get.find<PaymentDashboardController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: Colors.orange,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Tagihan'),
                  const SizedBox(height: 5),
                  Obx(
                    () => Text(
                      paymentDashboardController.totalFormatted,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Metode Pembayaran'),
                  Obx(
                    () => PaymentMethodWidget(
                      title: 'Cash',
                      value: 'cash',
                      selectedMethod:
                          paymentDashboardController.selectedMethod.value,
                      onChanged:
                          paymentDashboardController.onPaymentMethodChanged,
                    ),
                  ),
                  Obx(
                    () => PaymentMethodWidget(
                      title: 'QRIS',
                      value: 'qris',
                      selectedMethod:
                          paymentDashboardController.selectedMethod.value,
                      onChanged:
                          paymentDashboardController.onPaymentMethodChanged,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Obx(
                      () => Text(
                        paymentDashboardController.inputFormatted,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                CalculatorKeypad(
                  onButtonPressed: paymentDashboardController.onButtonPressed,
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: paymentDashboardController.processPayment,
                    child: const Text(
                      'Bayar',
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
