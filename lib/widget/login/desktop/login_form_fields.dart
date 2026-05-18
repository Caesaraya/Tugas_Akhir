import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';

class LoginFormFields extends StatelessWidget {
  final LoginController controller;
  const LoginFormFields({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Email
        const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller.emailController,
          decoration: InputDecoration(
            hintText: "Masukkan email Anda",
            prefixIcon: const Icon(Icons.email_outlined),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[200]!),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Input Password
        const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            decoration: InputDecoration(
              hintText: "Masukkan password",
              prefixIcon: const Icon(Icons.lock_outline),
              filled: true,
              fillColor: Colors.grey[50],
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Tombol Masuk
        SizedBox(
          width: double.infinity,
          height: 50,
          child: Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D3A1A),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.login(isDesktop: true),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Masuk",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Footer Text & Kebijakan
        const Text(
          "Dengan masuk, Anda setuju dengan penggunaan sistem sesuai kebijakan yang berlaku.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            "© 2026 Rumah Lezaa. All rights reserved.",
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ),
      ],
    );
  }
}
