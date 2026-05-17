import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'package:tugas_akhir/models/user.dart';
import 'package:tugas_akhir/routes/routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  final Rx<User?> currentUser = Rx<User?>(null);

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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
      _handleNavigation(user, isDesktop);
    } catch (error) {
      final message = error is Exception
          ? error.toString().replaceFirst('Exception: ', '')
          : 'Login gagal. Silakan coba lagi.';
      showError(message);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleNavigation(User user, bool isDesktop) {
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
   
        Get.offAllNamed(AppRoutes.kelolaProdukMob);
        break;
      default:
        showError('Role tidak dikenali untuk perangkat mobile');
    }
  }

  void navigateByRoleDesktop(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        Get.offAllNamed(AppRoutes.kelolaprodukdesk);
        break;
      case 'KASIR':
        Get.offAllNamed(AppRoutes.kasirboarddesk);
        break;
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
