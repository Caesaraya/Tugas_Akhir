import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({super.key});

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _restoreOrRedirect();
      });
    }
  }

  Future<void> _restoreOrRedirect() async {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 600;
    final loginController = Get.find<LoginController>();

    final restored = await loginController.restoreSession(isDesktop: isDesktop);
    if (!restored) {
      final route = isDesktop ? AppRoutes.logindesk : AppRoutes.login;
      Get.offAllNamed(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
