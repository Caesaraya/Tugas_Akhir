import 'package:get/get.dart';
import 'package:tugas_akhir/page/desktop/Kasir_dashboard_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_pembayaran_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_selesai_desktop.dart';
import 'package:tugas_akhir/page/mobile/Kasir_dashboard_mobile.dart';
import 'package:tugas_akhir/page/mobile/navbar_page.dart';
import 'package:tugas_akhir/page/mobile/kalkulator_mobile.dart';
import 'package:tugas_akhir/page/mobile/keranjang_mobile.dart';
import 'package:tugas_akhir/page/mobile/sukses_mobile_page.dart';
import 'package:tugas_akhir/page/mobile/riwayat_mobile.dart';
import 'routes.dart';

class AppPages {
  static final pages = [
    //mobile
    GetPage(
      name: AppRoutes.dashboardMobile,
      page: () => KasirDashboardMobile(),
    ),
    GetPage(name: AppRoutes.kalkulator,
      page: () => KalkulatorCashPage()
    ),
      GetPage(name: AppRoutes.sukses,
      page: () => SuksesMobilePage()
    ),
      GetPage(name: AppRoutes.keranjang,
      page: () => KeranjangMobilePage()
    ),
    GetPage(name: AppRoutes.navbar,
      page: () => NavbarPage()
    ),
    GetPage(name: AppRoutes.riwayat,
      page: () => RiwayatMobile()
    ),
    //desktop
    //kasir
    GetPage(
      name: AppRoutes.kasirboarddesk,
      page: () => KasirDashboardDesktop(),
    ),
    GetPage(name: AppRoutes.kasirbayar, page: () => KasirPembayaranDesktop()),
    GetPage(name: AppRoutes.kasirprint, page: () => KasirSelesaiDesktop()),
  ];
}
