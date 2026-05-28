import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';

class LoginFormFields extends StatefulWidget {
  final LoginController controller;
  const LoginFormFields({super.key, required this.controller});

  @override
  State<LoginFormFields> createState() => _LoginFormFieldsState();
}

class _LoginFormFieldsState extends State<LoginFormFields> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Email
        const Text(
          "Email",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller.emailController,
          decoration: InputDecoration(
            hintText: "nama@rumahlezaa.com",
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Input Password dengan Lupa Password
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Password",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            controller: widget.controller.passwordController,
            obscureText: !widget.controller.isPasswordVisible.value,
            decoration: InputDecoration(
              hintText: "••••••••",
              hintStyle: TextStyle(color: Colors.grey[400]),
              prefixIcon: const Icon(Icons.lock_outline, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.controller.isPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
                onPressed: widget.controller.togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // // Checkbox Ingat Saya
        // Row(
        //   children: [
        //     SizedBox(
        //       width: 24,
        //       height: 24,
        //       child: Checkbox(
        //         value: _rememberMe,
        //         activeColor: const Color(0xFFC86A37),
        //         shape: RoundedRectangleBorder(
        //           borderRadius: BorderRadius.circular(4),
        //         ),
        //         side: BorderSide(color: Colors.grey[300]!, width: 1.5),
        //         onChanged: (value) {
        //           setState(() {
        //             _rememberMe = value ?? false;
        //           });
        //         },
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //     const Text(
        //       "Ingat saya di perangkat ini",
        //       style: TextStyle(color: Colors.black54, fontSize: 13),
        //     ),
        //   ],
        // ),
        const SizedBox(height: 32),

        // Tombol Masuk ke Dasbor
        SizedBox(
          width: double.infinity,
          height: 52,
          child: Obx(
            () => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFFC86A37,
                ), // Warna oranye kecokelatan sesuai tombol gambar
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: widget.controller.isLoading.value
                  ? null
                  : () => widget.controller.login(isDesktop: true),
              child: widget.controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Footer & Syarat Ketentuan sesuai Gambar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "© 2024 Rumah Lezaa. All rights reserved.",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Bantuan",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                const Text(
                  "  •  ",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    "Syarat & Ketentuan",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
