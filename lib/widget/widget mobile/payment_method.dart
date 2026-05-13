import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';

class PaymentMethodSection extends StatelessWidget {
  final CartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Metode Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        
        // Pilihan Cash
        Obx(() => _buildPaymentItem(
          title: "Tunai / Cash",
          icon: Icons.money_outlined,
          value: "cash",
          isSelected: controller.selectedPayment.value == "cash",
        )),

        const SizedBox(height: 8),

        // Pilihan Virtual Account
        Obx(() => _buildPaymentItem(
          title: "Virtual Account",
          icon: Icons.account_balance_wallet_outlined,
          value: "va",
          isSelected: controller.selectedPayment.value == "va",
        )),
      ],
    );
  }

  Widget _buildPaymentItem({
    required String title,
    required IconData icon,
    required String value,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () => controller.selectedPayment.value = value,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.orange.shade900 : Colors.grey.shade300,
            width: 1.5,
          ),
          color: isSelected ? Colors.orange.shade50 : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.orange.shade900 : Colors.grey),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.orange.shade900 : Colors.black,
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Colors.orange.shade900 : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}