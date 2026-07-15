import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
// IMPORT FILE WARNA KAMU (Sesuaikan dengan path projectmu)
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/login/login_button.dart';
import 'package:tugas_akhir/widget/login/login_divider.dart';
import 'package:tugas_akhir/widget/login/login_email.dart';
import 'package:tugas_akhir/widget/login/login_password.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final LoginController ctrl = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    // Mengambil tinggi layar untuk pembagian background secara dinamis
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.ba,
      body: Stack(
        children: [
          // 1. BACKGROUND SPLIT (Atas Oranye, Bawah Abu-abu)
          Column(
            children: [
              Container(
                height:
                    screenHeight * 0.4, // 40% tinggi layar untuk warna oranye
                color: AppColors.ba, // Menggunakan warna oranye kamu
              ),
              Expanded(child: Container(color: AppColors.ba)),
            ],
          ),

          // 2. KONTEN UTAMA (Scrollable agar aman dari keyboard overflow)
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // LOGO AREA
                  SizedBox(
                    height: 150,
                    child: Center(
                      child: Image.asset(
                        'assets/Logo_Rumah_Lezaa-removebg-preview.png',
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // FLOATING LOGIN CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        36,
                      ), // Membuat semua sudut melengkung
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26, // Soft shadow
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const LoginDivider(),
                        const SizedBox(height: 24),

                        // Email Field
                        EmailField(controller: ctrl.emailController),
                        const SizedBox(height: 30),

                        // Password Field
                        PasswordField(
                          controller: ctrl.passwordController,
                          loginCtrl: ctrl,
                        ),
                        const SizedBox(height: 50),

                        // Log In Button
                        LoginButton(loginCtrl: ctrl),
                        const SizedBox(height: 20),

                        // Forgot Password (Di dalam Card)
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    "© 2024 Rumah Lezaa. All rights reserved.",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
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
