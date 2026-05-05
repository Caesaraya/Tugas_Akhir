import 'package:flutter/material.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String title;
  final String value;
  final String selectedMethod;
  final ValueChanged<String?> onChanged;

  const PaymentMethodWidget({
    super.key,
    required this.title,
    required this.value,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Radio<String>(
            value: value,
            groupValue: selectedMethod,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
