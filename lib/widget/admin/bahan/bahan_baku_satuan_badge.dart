// lib/views/widgets/bahan_baku/bahan_baku_satuan_badge.dart
import 'package:flutter/material.dart';

class BahanBakuSatuanBadge extends StatelessWidget {
  const BahanBakuSatuanBadge({super.key, required this.satuan});

  final String satuan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        satuan,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF388E3C),
        ),
      ),
    );
  }
}
