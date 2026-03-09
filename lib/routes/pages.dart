import 'package:get/get.dart';
import 'package:tugas_akhir/page/dashboard_mobile.dart';
import 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.dashboardMobile, page: () => DashboardMobilePage()),
  ];
}