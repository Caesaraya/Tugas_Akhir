// lib/views/widgets/bahan_baku/bahan_baku_stok_badge.dart
import 'package:flutter/material.dart';

class BahanBakuStokBadge extends StatelessWidget {
  const BahanBakuStokBadge({super.key, required this.stok});

  final int stok;

  @override
  Widget build(BuildContext context) {
    final isLow = stok <= 10;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isLow ? const Color(0xFFFFEBEE) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLow) ...[
            const Icon(
              Icons.warning_amber_rounded,
              size: 12,
              color: Color(0xFFEF5350),
            ),
            const SizedBox(width: 3),
          ],
          Text(
            '$stok',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isLow ? const Color(0xFFEF5350) : const Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }
}
