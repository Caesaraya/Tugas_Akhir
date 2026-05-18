import 'package:flutter/material.dart';

class HeaderFormWidget extends StatelessWidget {
  const HeaderFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Image.asset(
            'assets/Logo_Rumah_Lezaa-removebg-preview.png',
            height: 140,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Selamat datang kembali!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3E2723),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          "Silakan masuk ke akun Anda",
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}
