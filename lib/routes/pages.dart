import 'package:get/get.dart';
import 'package:tugas_akhir/page/dashboard_mobile.dart';
import 'package:tugas_akhir/page/keranjang_mobile.dart';
import 'package:tugas_akhir/page/navbar_page.dart';
import 'package:tugas_akhir/page/sukses_mobile_page.dart';
import 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.dashboardMobile, page: () => DashboardMobilePage()),
    GetPage(name: AppRoutes.navbar, page: () => NavbarPage()),
    GetPage(name: AppRoutes.keranjang, page: () => KeranjangMobilePage()),
    GetPage(name: AppRoutes.sukses, page: () => SuksesMobilePage()),
  ];
}