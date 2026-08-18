import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/user.dart';
import 'package:tugas_akhir/routes/routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final Rx<User?> currentUser = Rx<User?>(null);
  static const String userSessionKey = 'user_session';

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userSessionKey, jsonEncode(user.toJson()));
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userSessionKey);
    currentUser.value = null;
  }

  Future<bool> restoreSession({required bool isDesktop}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(userSessionKey);
      if (jsonString == null || jsonString.isEmpty) {
        return false;
      }

      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      final user = User.fromJson(data);

      if (!user.isAdmin && !user.isKasir && !user.isBakery) {
        await clearSession();
        return false;
      }

      currentUser.value = user;
      handleNavigation(user, isDesktop);
      return true;
    } catch (_) {
      await clearSession();
      return false;
    }
  }

  Future<void> logout() async {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      middleText: 'Apakah kamu yakin ingin keluar dari akun?',
      textCancel: 'Batal',
      textConfirm: 'Logout',
      buttonColor: Colors.red,
      onCancel: () {},
      onConfirm: () async {
        Get.back(); // Tutup dialog

        await clearSession();
        Get.offAllNamed(AppRoutes.mediaQuery);
      },
    );
  }

  Future<void> login({required bool isDesktop}) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showError('Email dan password tidak boleh kosong');
      return;
    }

    isLoading.value = true;

    try {
      final responseData = await ApiService.login(
        email: email,
        password: password,
      );

      final user = User.fromJson(responseData);
      currentUser.value = user;
      await saveSession(user);
      emailController.clear();
      passwordController.clear();

      handleNavigation(user, isDesktop);
    } catch (error) {
      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : 'Login gagal. Silakan coba lagi.';
      showError(message);
    } finally {
      isLoading.value = false;
    }
  }

  void handleNavigation(User user, bool isDesktop) {
    if (isDesktop) {
      navigateByRoleDesktop(user.role);
    } else {
      navigateByRoleMobile(user.role);
    }
  }

  void navigateByRoleMobile(String role) {
    switch (role.toUpperCase()) {
      case 'KASIR':
        Get.offAllNamed(AppRoutes.dashboardMobile);
        break;
      case 'ADMIN':
        Get.offAllNamed(AppRoutes.dashboardMob);
        break;
      case 'BAKERY':
        Get.offAllNamed(AppRoutes.bakery);
        break;
      default:
        showError('Role tidak dikenali untuk perangkat mobile');
    }
  }

  void navigateByRoleDesktop(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        Get.offAllNamed(AppRoutes.dashboarddesk);
        break;
      case 'KASIR':
        Get.offAllNamed(AppRoutes.kasirboarddesk);
        break;
      case 'BAKERY':
        Get.offAllNamed(AppRoutes.bakery);
      default:
        showError('Role tidak dikenali untuk perangkat desktop');
    }
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
