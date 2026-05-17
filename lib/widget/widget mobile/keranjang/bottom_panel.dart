import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/payment_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/keranjang/payment_method.dart';
import 'package:tugas_akhir/widget/widget desktop/detail_transaction/row.dart';
import 'package:get/get.dart';

class KeranjangBottomPanel extends StatelessWidget {
  final PaymentController ctrl;
 
  const KeranjangBottomPanel({super.key, required this.ctrl});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PaymentMethodSection(),
            const SizedBox(height: 12),
            const Divider(thickness: 1),
            SummaryRow(
              label: 'Subtotal',
              value: ctrl.subtotalFormatted,
              color: Colors.grey,
            ),
            Obx(() => ctrl.hasDiskon
                ? Column(
                    children: [
                      const SizedBox(height: 4),
                      SummaryRow(
                        label: 'Potongan Diskon',
                        value: ctrl.diskonFormatted,
                        color: Colors.red,
                        isBold: true,
                      ),
                    ],
                  )
                : const SizedBox.shrink()),
 
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(thickness: 1),
            ),
            SummaryRow(
              label: 'Total Pesanan:',
              value: ctrl.totalFormatted,
              isBold: true,
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89336),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: ctrl.bayarSekarang,
                child: const Text(
                  'Bayar Sekarang',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}