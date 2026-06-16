import 'package:flutter/material.dart';

class HeaderFormWidget extends StatelessWidget {
  const HeaderFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mini Preview Image / Logo atas (berdasarkan gambar mock-up kecil)
        Row(
          children: [
            Image.asset(
              'assets/Logo_Rumah_Lezaa-removebg-preview.png',
              height: 120,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.bakery_dining, color: Color(0xFFC86A37)),
            ),
          ],
        ),
        const SizedBox(height: 40),
        const Text(
          "Selamat datang kembali!",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Silakan masuk ke akun Anda",
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ],
    );
  }
}
