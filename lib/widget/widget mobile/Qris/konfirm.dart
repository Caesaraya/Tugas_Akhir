import 'package:flutter/material.dart';

class KonfirmasiCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const KonfirmasiCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            activeColor: const Color(0xFFE89336),
            onChanged: onChanged,
          ),
          const Expanded(
            child: Text(
              'Saya konfirmasi foto di atas adalah bukti pembayaran QRIS yang valid',
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}