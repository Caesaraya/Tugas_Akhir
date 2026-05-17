import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/page/login/desktop_login_page.dart';
import 'package:tugas_akhir/page/login/login_page.dart';

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();

    // Gunakan FutureBuilder untuk mengecek sesi aktif saat aplikasi pertama kali dibuka
    return FutureBuilder<bool>(
      future: loginController.restoreSession(
        // Berikan nilai default awal pengecekan desktop berdasarkan ukuran layar saat ini
        isDesktop: MediaQuery.of(context).size.width >= 600,
      ),
      builder: (context, snapshot) {
        // Tampilkan loading screen sementara memuat sesi data lokal (SharedPreferences)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF5D3A1A)),
            ),
          );
        }

        // Jika user ternyata SUDAH LOGIN (Sesi berhasil di-restore),
        // fungsi restoreSession di LoginController akan otomatis mengarahkan ke dashboard utama.
        // Kita cukup kembalikan widget kosong selama proses transisi rute tersebut.
        if (snapshot.data == true) {
          return const SizedBox.shrink();
        }

        // Jika user BELUM LOGIN (Sesi kosong), gunakan LayoutBuilder untuk memantau
        // perubahan ukuran layar secara langsung (bisa bolak-balik diganti versinya).
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return DesktopLoginPage(); // Menampilkan UI Versi Desktop
            } else {
              return LoginPage(); // Menampilkan UI Versi Mobile
            }
          },
        );
      },
    );
  }
}
