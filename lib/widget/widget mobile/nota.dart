import 'package:flutter/material.dart';

class Nota extends StatelessWidget {
  final double total;
  final String metode;
  final double bayar;
  final double kembalian;

  const Nota({
    super.key,
    required this.total,
    required this.metode,
    required this.bayar,
    required this.kembalian,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "RUMAH LEZAA",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Text("Bakery & Cake Custom"),
        const Divider(thickness: 1, height: 30),
        
        _buildRow("Total Tagihan", "Rp ${total.toInt()}"),
        _buildRow(metode, "Rp ${bayar.toInt()}"),
        
        const Divider(thickness: 1, height: 30),
        
        _buildRow("Kembalian", "Rp ${kembalian.toInt()}", isBold: true),
        
        const SizedBox(height: 20),
        const Text(
          "Terima Kasih Atas Kunjungannya",
          style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}