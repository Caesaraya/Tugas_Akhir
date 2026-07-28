import 'package:flutter/material.dart';

class TotalTagihanCard extends StatelessWidget {
  final String totalFormatted;

  const TotalTagihanCard({super.key, required this.totalFormatted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text(
            'Total Tagihan',
            style: TextStyle(fontSize: 14, color: Color(0xFFE89336)),
          ),
          const SizedBox(height: 8),
          Text(
            totalFormatted,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}