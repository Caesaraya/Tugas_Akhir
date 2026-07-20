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
    final isDesktop = MediaQuery.sizeOf(context).width >= 600;

    return FutureBuilder<bool>(
      future: loginController.restoreSession(isDesktop: isDesktop),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF5D3A1A)),
            ),
          );
        }

        if (snapshot.data == true) {
          return const SizedBox.shrink();
        }

        return isDesktop ? DesktopLoginPage() : LoginPage();
      },
    );
  }
}