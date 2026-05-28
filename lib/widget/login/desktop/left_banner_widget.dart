import 'package:flutter/material.dart';

class LeftBannerWidget extends StatelessWidget {
  const LeftBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF4A2E1B), // Warna cokelat gelap sesuai gambar
      child: Stack(
        children: [
          // Background Icon / Pattern (Bisa disesuaikan opacity-nya)
          Positioned(
            right: -50,
            bottom: -50,
            child: Icon(
              Icons.cookie_outlined,
              size: 400,
              color: Colors.black.withOpacity(0.05),
            ),
          ),
          Positioned(
            left: 40,
            bottom: 150,
            child: Icon(
              Icons.bakery_dining_outlined,
              size: 200,
              color: Colors.white.withOpacity(0.05),
            ),
          ),

          // Konten Teks
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Rumah Lezaa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Kelola data penjualan, stok roti, dan panggangan hanya dalam satu dasbor terintegrasi. Modernitas pengrajin roti dalam setiap data.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),

                // Indikator halaman (garis oranye & abu-abu)
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC86A37),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
