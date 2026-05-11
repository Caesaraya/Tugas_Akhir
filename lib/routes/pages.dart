import 'package:get/get.dart';
import 'package:tugas_akhir/bindings/admin/admin_binding.dart';
import 'package:tugas_akhir/page/admin/kelola_bahan_desktop.dart';
import 'package:tugas_akhir/page/admin/kelola_produk_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_dashboard_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_pembayaran_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_selesai_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_riwayat_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_kelola_produk.dart';
import 'package:tugas_akhir/page/desktop/transaction_detail_desktop.dart';
import 'package:tugas_akhir/page/media_query.dart';
import 'package:tugas_akhir/page/mobile/Kasir_dashboard_mobile.dart';
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
    GetPage(
      name: AppRoutes.transactionDetail,
      page: () => DetailScreen(data: Get.arguments),
    ),
    GetPage(name: AppRoutes.riwayatdesk, page: () => KasirRiwayatDesktop()),
    GetPage(name: AppRoutes.kelolaProduk, page: () => ProductPage()),
  ];
}
