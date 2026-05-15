import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/models/user.dart';
import 'package:tugas_akhir/routes/routes.dart';
 
class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
 
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
 
  // ─── Hardcode user kasir (sementara) ─────────────────────────────────────
  static final User kasirUser = User(
    id: 1,
    name: 'Kasir',
    email: 'kasir@gmail.com',
    password: '123456',
    role: 'KASIR',
  );
 
  // ─── User yang sedang login (bisa diakses controller lain) ────────────────
  final Rx<User?> currentUser = Rx<User?>(null);
 
  // ─── Toggle visibility password ───────────────────────────────────────────
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
 
  // ─── Proses login ─────────────────────────────────────────────────────────
  void login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
 
    if (email.isEmpty || password.isEmpty) {
      showError('Email dan password tidak boleh kosong');
      return;
    }
 
    isLoading.value = true;
 
    Future.delayed(const Duration(milliseconds: 800), () {
      isLoading.value = false;
 
      if (email == kasirUser.email && password == kasirUser.password) {
        currentUser.value = kasirUser;
        navigateByRole(kasirUser.role);
      } else {
        showError('Email atau password salah');
      }
    });
  }
 
  // ─── Navigasi berdasarkan role ────────────────────────────────────────────
  void navigateByRole(String role) {
    switch (role.toUpperCase()) {
      case 'KASIR':
        Get.offAllNamed(AppRoutes.navbar);
        break;
      default:
        showError('Role tidak dikenali');
    }
  }
 
  // ─── Logout ───────────────────────────────────────────────────────────────
  void logout() {
    currentUser.value = null;
    emailController.clear();
    passwordController.clear();
    Get.offAllNamed(AppRoutes.login);
  }
 

  void showError(String message) {
    Get.snackbar(
      'Login Gagal',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }
 
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}