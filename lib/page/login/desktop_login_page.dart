import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/widget/login/desktop/header_form_widget.dart';
import 'package:tugas_akhir/widget/login/desktop/left_banner_widget.dart';
import 'package:tugas_akhir/widget/login/desktop/login_form_fields.dart';
// Import widget pecahan kamu di sini, contoh:
// import 'widgets/left_banner_widget.dart';
// import 'widgets/header_form_widget.dart';
// import 'widgets/login_form_fields.dart';

class DesktopLoginPage extends StatelessWidget {
  DesktopLoginPage({super.key});
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // 1. SISI KIRI: BANNER (Hanya muncul di layar lebar > 800px)
          if (screenSize.width > 800)
            const Expanded(flex: 6, child: LeftBannerWidget()),

          // 2. SISI KANAN: FORM LOGIN
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderFormWidget(), // Komponen Header (Logo & Title)
                        const SizedBox(height: 24),
                        LoginFormFields(
                          controller: controller,
                        ), // Komponen Form Input & Button
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
