import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';

class BahanBakuDetailHeader extends StatelessWidget {
  final BahanBaku bahanBaku;

  const BahanBakuDetailHeader({super.key, required this.bahanBaku});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_2,
              size: 80,
              color: Color(0xFF5D4037),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          bahanBaku.namaBahan,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        Text(
          bahanBaku.merk,
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const Divider(height: 40),
      ],
    );
  }
}
