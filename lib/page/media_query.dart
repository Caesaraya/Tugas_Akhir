import 'package:flutter/material.dart';
import 'package:tugas_akhir/page/login/desktop_login_page.dart';
import 'package:tugas_akhir/page/login/login_page.dart';

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // breakpoint: tablet dianggap desktop
    if (width >= 600) {
      return DesktopLoginPage();
    } else {
      return LoginPage();
    }
  }
}
