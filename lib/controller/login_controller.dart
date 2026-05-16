import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/models/user.dart';
import 'package:tugas_akhir/routes/routes.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  // Data tiruan / mock API sesuai dengan struktur Model User
  static final User kasirUser = User(
    id: 1,
    name: 'Kasir',
    email: 'kasir@gmail.com',
    password: '123',
    role: 'KASIR',
  );

  static final User adminUser = User(
    id: 2,
    name: 'Admin Toko',
    email: 'admin@gmail.com',
    password: '123',
    role: 'ADMIN',
  );

  final Rx<User?> currentUser = Rx<User?>(null);

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Menambahkan parameter isDesktop untuk membedakan asal login
  void login({required bool isDesktop}) {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showError('Email dan password tidak boleh kosong');
      return;
    }

    isLoading.value = true;

    // Simulasi hit API (Nanti bagian ini tinggal diganti dengan HTTP request/Dio)
    Future.delayed(const Duration(milliseconds: 800), () {
      isLoading.value = false;

      // Pengecekan data login disesuaikan dengan data model
      if (email == kasirUser.email && password == kasirUser.password) {
        currentUser.value = kasirUser;
        _handleNavigation(kasirUser, isDesktop);
      } else if (email == adminUser.email && password == adminUser.password) {
        currentUser.value = adminUser;
        _handleNavigation(adminUser, isDesktop);
      } else {
        showError('Email atau password salah');
      }
    });
  }

  // Fungsi internal untuk mengarahkan navigasi berdasarkan user dan platform
  void _handleNavigation(User user, bool isDesktop) {
    if (isDesktop) {
      navigateByRoleDesktop(user.role);
    } else {
      navigateByRoleMobile(user.role);
    }
  }

  // Navigasi Khusus Mobile
  void navigateByRoleMobile(String role) {
    switch (role.toUpperCase()) {
      case 'KASIR':
        Get.offAllNamed(AppRoutes.navbar); // Route utama kasir di mobile
        break;
      case 'ADMIN':
        // Jika admin membuka mobile, arahkan ke halaman yang sesuai (atau samakan)
        Get.offAllNamed(AppRoutes.kelolaProdukMob); // Route admin mobile
        break;
      default:
        showError('Role tidak dikenali untuk perangkat mobile');
    }
  }

  // Navigasi Khusus Desktop
  void navigateByRoleDesktop(String role) {
    switch (role.toUpperCase()) {
      case 'ADMIN':
        Get.offAllNamed(AppRoutes.kelolaprodukdesk); // Route admin desktop
        break;
      case 'KASIR':
        // Jika kasir login di desktop, arahkan ke layout desktopnya (jika ada)
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
