import 'package:get/get.dart';
import 'package:tugas_akhir/page/desktop/Kasir_dashboard_desktop.dart';
import 'package:tugas_akhir/page/mobile/Kasir_dashboard_mobile.dart';
import 'package:tugas_akhir/page/mobile/navbar_page.dart';
import 'routes.dart';

class AppPages {
  static final pages = [
    //mobile
    GetPage(
      name: AppRoutes.dashboardMobile,
      page: () => KasirDashboardMobile(),
    ),
    GetPage(name: AppRoutes.navbar, page: () => NavbarPage()),
    //desktop
    GetPage(
      name: AppRoutes.kasirboarddesk,
      page: () => KasirDashboardDesktop(),
    ),
  ];
}
