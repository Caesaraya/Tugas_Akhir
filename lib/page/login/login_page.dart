import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
// 1. IMPORT FILE WARNA KAMU (Sesuaikan dengan path projectmu)
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
    return Scaffold(
      // 2. GANTI WARNA DI SINI
      backgroundColor: AppColors.primaryOrange,
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Center(
              child: Image.asset(
                'assets/Logo_Rumah_Lezaa-removebg-preview.png',
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                // 3. GANTI WARNA DI SINI
                color: AppColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginDivider(),
                  const SizedBox(height: 20),
                  EmailField(controller: ctrl.emailController),
                  const SizedBox(height: 12),
                  PasswordField(
                    controller: ctrl.passwordController,
                    loginCtrl: ctrl,
                  ),
                  const SizedBox(height: 24),
                  LoginButton(loginCtrl: ctrl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
