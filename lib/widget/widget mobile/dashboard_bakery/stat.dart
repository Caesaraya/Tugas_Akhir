import 'package:flutter/material.dart';

class BakeryStatsRow extends StatelessWidget {
  final int jumlahBahan;
  const BakeryStatsRow({super.key, required this.jumlahBahan});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          StatItem(icon: Icons.timer_outlined, value: '30 Mnt', label: 'Waktu'),
          Container(width: 1, height: 36, color: Colors.grey.shade200),
          StatItem(
            icon: Icons.local_fire_department_outlined,
            value: '$jumlahBahan Bahan',
            label: 'Bahan',
          ),
          Container(width: 1, height: 36, color: Colors.grey.shade200),
          StatItem(icon: Icons.bar_chart, value: 'Mudah', label: 'Level'),
        ],
      ),
    );
  }
}

class StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFE89336), size: 22),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        Text(label,
            style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}