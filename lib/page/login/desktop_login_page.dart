import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/login/desktop/header_form_widget.dart';
import 'package:tugas_akhir/widget/login/desktop/left_banner_widget.dart';
import 'package:tugas_akhir/widget/login/desktop/login_form_fields.dart';

class DesktopLoginPage extends StatelessWidget {
  DesktopLoginPage({super.key});
  final LoginController ctrl = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // SISI KIRI: Banner Dinamis / Carousel Foto
          const Expanded(flex: 5, child: LeftBannerWidget()),

          // SISI KANAN: Form Login dengan Perbaikan Penyelarasan Vertikal
          Expanded(
            flex: 5,
            child: Center(
              // <-- MEMBUAT FORM LOGIN TEPAT DI TENGAH LAYAR SECARA VERTIKAL
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 56.0,
                  vertical: 40.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 480,
                  ), // Menjaga form tidak terlalu melebar pada layar ultra-wide
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderFormWidget(),
                      const SizedBox(
                        height: 40,
                      ), // <-- JARAK LEBIH LEGA SETELAH HEADER/LOGO
                      LoginFormFields(controller: ctrl),
                    ],
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
