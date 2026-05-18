import 'package:flutter/material.dart';

class LeftBannerWidget extends StatelessWidget {
  const LeftBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF5D3A1A),
      child: Stack(
        children: [
          Positioned(
            right: -100,
            bottom: -100,
            child: Icon(
              Icons.bakery_dining_outlined,
              size: 500,
              color: Colors.white10,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rumah Lezaa",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Kelola data penjualan, stok roti, dan panggangan\nhanya dalam satu dasbor terintegrasi.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
