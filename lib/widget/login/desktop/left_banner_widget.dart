import 'package:flutter/material.dart';
// 1. IMPORT FILE WARNA KAMU
import 'package:tugas_akhir/utils/app_color.dart';

class LeftBannerWidget extends StatelessWidget {
  const LeftBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 2. GANTI WARNA DI SINI
      color: AppColors.buttonlogin,
      child: Stack(
        children: [
          Positioned(
            right: -50,
            bottom: -50,
            child: Icon(
              Icons.cookie_outlined,
              size: 400,
              // 3. GANTI WARNA DI SINI
              color: AppColors.iconMutedLight,
            ),
          ),
          Positioned(
            left: 40,
            bottom: 150,
            child: Icon(
              Icons.bakery_dining_outlined,
              size: 200,
              // 4. GANTI WARNA DI SINI
              color: AppColors.iconMutedLight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Rumah Lezaa",
                  style: TextStyle(
                    // 5. GANTI WARNA DI SINI
                    color: AppColors.textWhite,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Kelola data penjualan, stok roti, dan panggangan hanya dalam satu dasbor terintegrasi. Modernitas pengrajin roti dalam setiap data.",
                  style: TextStyle(
                    // 6. GANTI WARNA DI SINI
                    color: AppColors.textWhiteMuted,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        // 7. GANTI WARNA DI SINI
                        color: AppColors.accentOrange,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 4,
                      decoration: BoxDecoration(
                        // 8. GANTI WARNA DI SINI
                        color: AppColors
                            .textWhiteMuted, // (Bisa pakai AppColors.textWhite.withOpacity(0.3) jika tidak ingin di-hardcode di class)
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 16,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.textWhiteMuted,
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
