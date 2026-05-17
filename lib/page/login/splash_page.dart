import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

/// Halaman splash — tampil sebentar sambil [LoginController.onInit]
/// mengecek sesi tersimpan di background.
///
/// Alur:
/// - Ada sesi  → [LoginController._checkSession] navigasi otomatis ke dashboard
/// - Tidak ada → splash redirect ke [AppRoutes.login] setelah delay
///
/// Layout desktop/mobile ditangani oleh MediaQuery di dalam [LoginPage],
/// bukan di sini.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final ctrl = Get.find<LoginController>();

    // Beri waktu _checkSession selesai.
    // Jika ada sesi, controller sudah navigasi sendiri sebelum delay habis.
    await Future.delayed(const Duration(milliseconds: 1800));

    // Jika belum navigasi (tidak ada sesi), arahkan ke login.
    // Satu route — LoginPage yang adaptif via MediaQuery.
    if (ctrl.currentUser.value == null) {
      Get.offAllNamed(AppRoutes.mediaQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE89336),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bakery_dining_outlined,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'Toko Roti',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
