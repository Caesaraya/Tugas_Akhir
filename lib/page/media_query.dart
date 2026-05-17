import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/page/login/desktop_login_page.dart';
import 'package:tugas_akhir/page/login/login_page.dart';
import 'package:tugas_akhir/routes/routes.dart';

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // Navigate to the appropriate named route so bindings are applied
    final route = width >= 600 ? AppRoutes.logindesk : AppRoutes.login;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(route);
    });
    return const SizedBox.shrink();
  }
}
