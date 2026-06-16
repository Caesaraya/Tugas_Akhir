import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/widget/login/desktop/header_form_widget.dart';
import 'package:tugas_akhir/widget/login/desktop/left_banner_widget.dart';
import 'package:tugas_akhir/widget/login/desktop/login_form_fields.dart';

class DesktopLoginPage extends StatelessWidget {
  DesktopLoginPage({super.key});
  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // 1. SISI KIRI: BANNER (Flex 5 agar seimbang 50:50 atau sesuaikan kebutuhan)
          if (screenSize.width > 800)
            const Expanded(flex: 5, child: LeftBannerWidget()),

          // 2. SISI KANAN: FORM LOGIN
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 64,
                    vertical: 32,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 460,
                    ), // Diperlebar agar layout horizontal di footer muat
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderFormWidget(),
                        const SizedBox(height: 32),
                        LoginFormFields(controller: controller),
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
