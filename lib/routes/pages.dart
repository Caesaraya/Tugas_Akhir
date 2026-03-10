import 'package:get/get.dart';
import 'package:tugas_akhir/page/dashboard_mobile.dart';
import 'package:tugas_akhir/page/navbar_page.dart';
import 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.dashboardMobile, page: () => DashboardMobilePage()),
    GetPage(name: AppRoutes.navbar, page: () => NavbarPage()),
  ];
}