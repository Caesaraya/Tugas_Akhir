import 'package:flutter/material.dart';
import 'package:tugas_akhir/page/desktop/Kasir_dashboard_desktop.dart';
import 'package:tugas_akhir/page/mobile/Kasir_dashboard_mobile.dart';

class DashboardWrapper extends StatelessWidget {
  const DashboardWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    // breakpoint: tablet dianggap desktop
    if (width >= 600) {
      return KasirDashboardDesktop();
    } else {
      return KasirDashboardMobile();
    }
  }
}
