import 'package:get/get.dart';
import 'package:tugas_akhir/bindings/admin/admin_binding.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_bahan_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_produk_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_resep_desktop.dart';
import 'package:tugas_akhir/page/admin/mobile/bahanbaku/kelola_bahan_baku_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/produk/kelola_produk_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/resep/kelola_resep_mobile.dart';
import 'package:tugas_akhir/page/desktop/Kasir_dashboard_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_pembayaran_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_selesai_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_riwayat_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_kelola_dashboard.dart';
import 'package:tugas_akhir/page/desktop/transaction_detail_desktop.dart';
import 'package:tugas_akhir/page/login/desktop_login_page.dart';
import 'package:tugas_akhir/page/media_query.dart';
import 'package:tugas_akhir/page/mobile/Kasir_dashboard_mobile.dart';
import 'package:tugas_akhir/page/login/login_page.dart';
import 'package:tugas_akhir/page/mobile/navbar_page.dart';
import 'package:tugas_akhir/page/mobile/kalkulator_mobile.dart';
import 'package:tugas_akhir/page/mobile/keranjang_mobile.dart';
import 'package:tugas_akhir/page/mobile/sukses_mobile_page.dart';
import 'package:tugas_akhir/page/mobile/riwayat_mobile.dart';
import 'package:tugas_akhir/page/mobile/Kelolaproduk_mobile.dart';

import 'routes.dart';

class AppPages {
  static final pages = [
    //===ADMIN===
    //desktop
    GetPage(
      name: AppRoutes.kelolaprodukdesk,
      page: () => KelolaProdukDeskPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.kelolabahandesk,
      page: () => BahanBakuScreen(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.kelolaresepdesk,
      page: () => KelolaResepDeskPage(),
      binding: AdminBinding(),
    ),
    //mobile
    GetPage(
      name: AppRoutes.kelolaProdukMob,
      page: () => ProductListPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.kelolaBahanMob,
      page: () => BahanBakuListPage(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: AppRoutes.kelolaResepMob,
      page: () => KelolaResepMobilePage(),
      binding: AdminBinding(),
    ),
    //media query
    GetPage(name: AppRoutes.mediaQuery, page: () => DashboardWrapper()),
    //===KASIR===
    //mobile
    GetPage(
      name: AppRoutes.dashboardMobile,
      page: () => KasirDashboardMobile(),
    ),
    GetPage(name: AppRoutes.kalkulator, page: () => KalkulatorCashPage()),
    GetPage(name: AppRoutes.sukses, page: () => SuksesMobilePage()),
    GetPage(name: AppRoutes.keranjang, page: () => KeranjangMobilePage()),
    GetPage(name: AppRoutes.navbar, page: () => NavbarPage()),
    GetPage(name: AppRoutes.riwayat, page: () => RiwayatMobile()),
    GetPage(name: AppRoutes.kelolaProduk, page: () => KelolaProdukPage()),
    //desktop
    //kasir
    GetPage(
      name: AppRoutes.kasirboarddesk,
      page: () => KasirDashboardDesktop(),
    ),
    GetPage(name: AppRoutes.kasirbayar, page: () => KasirPembayaranDesktop()),
    GetPage(name: AppRoutes.kasirprint, page: () => KasirSelesaiDesktop()),
    GetPage(name: AppRoutes.transactionDetail, page: () => DetailScreen()),
    GetPage(name: AppRoutes.riwayatdesk, page: () => KasirRiwayatDesktop()),
    GetPage(
      name: AppRoutes.kelolaprodukdashboard,
      page: () => KasirKelolaDashboard(),
    ),
    //===LOGIN===
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.logindesk, page: () => DesktopLoginPage()),
  ];
}
