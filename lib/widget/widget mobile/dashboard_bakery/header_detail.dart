import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/resep.dart';

class BakeryHeaderDetail extends StatelessWidget {
  final Resep resep;
  const BakeryHeaderDetail({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: const Color(0xFFFFF3E0),
          child: const Icon(
            Icons.menu_book_outlined,
            size: 80,
            color: Color(0xFFE89336),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(height: 80, decoration: BoxDecoration()),
        ),
        Positioned(
          bottom: 16,
          left: 20,
          right: 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (resep.deskripsi.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(bottom: 8),
                ),
              Text(
                resep.namaResep,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
