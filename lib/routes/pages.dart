import 'package:get/get.dart';
import 'package:tugas_akhir/page/admin/desktop/dashboard_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_bahan_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_produk_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_resep_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_user_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/laporan_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/monitoring_keuangan_desktop.dart';
import 'package:tugas_akhir/page/admin/mobile/bahanbaku/kelola_bahan_baku_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/dashboard_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/laporan/laporan_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/produk/kelola_produk_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/resep/kelola_resep_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/uang/monitoring_keuangan_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/user/kelola_user_mobile.dart';
import 'package:tugas_akhir/page/desktop/Kasir_dashboard_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_pembayaran_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_selesai_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_riwayat_desktop.dart';
import 'package:tugas_akhir/page/desktop/Kasir_kelola_dashboard.dart';
import 'package:tugas_akhir/page/desktop/lapor_dashboard_desktop.dart';
import 'package:tugas_akhir/page/desktop/transaction_detail_desktop.dart';
import 'package:tugas_akhir/page/login/desktop_login_page.dart';
import 'package:tugas_akhir/page/login/splash_page.dart';
import 'package:tugas_akhir/page/media_query.dart';
import 'package:tugas_akhir/page/mobile/Kasir_dashboard_mobile.dart';
import 'package:tugas_akhir/page/login/login_page.dart';
import 'package:tugas_akhir/page/mobile/bakery_bahan.dart';
import 'package:tugas_akhir/page/mobile/bakery_mobile.dart';
import 'package:tugas_akhir/page/mobile/bakery_mobile_detail.dart';
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';
import 'package:tugas_akhir/page/mobile/kalkulator_mobile.dart';
import 'package:tugas_akhir/page/mobile/keranjang_mobile.dart';
import 'package:tugas_akhir/page/mobile/lapor_produk.dart';
import 'package:tugas_akhir/page/mobile/qris_payment_page.dart';
import 'package:tugas_akhir/page/mobile/sukses_mobile_page.dart';
import 'package:tugas_akhir/page/mobile/riwayat_mobile.dart';
import 'package:tugas_akhir/page/mobile/Kelolaproduk_mobile.dart';
import 'package:tugas_akhir/page/mobile/transaction_detail_mobile.dart';

import 'routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    // ── Login ──────────────────────────────────────────────────────────────
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.logindesk, page: () => DesktopLoginPage()),
    GetPage(name: AppRoutes.mediaQuery, page: () => DashboardWrapper()),

    // ── Kasir Mobile ───────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.dashboardMobile,
      page: () => KasirDashboardMobile(),
    ),
    GetPage(name: AppRoutes.keranjang, page: () => KeranjangMobilePage()),
    GetPage(name: AppRoutes.kalkulator, page: () => KalkulatorCashPage()),
    GetPage(name: AppRoutes.sukses, page: () => SuksesMobilePage()),
    GetPage(name: AppRoutes.riwayat, page: () => RiwayatMobile()),
    GetPage(name: AppRoutes.kelolaProduk, page: () => KelolaProdukPage()),
    GetPage(
      name: AppRoutes.transactionDetailMobile,
      page: () => TransactionDetailMobile(),
    ),
    GetPage(name: AppRoutes.kasirmobiledrawer, page: () => KasirMobileDrawer()),
    GetPage(name: AppRoutes.laporProduk, page: () => LaporProdukPage()),

    // ── Kasir Desktop ──────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.kasirboarddesk,
      page: () => KasirDashboardDesktop(),
    ),
    GetPage(name: AppRoutes.kasirbayar, page: () => KasirPembayaranDesktop()),
    GetPage(name: AppRoutes.kasirprint, page: () => KasirSelesaiDesktop()),
    GetPage(name: AppRoutes.riwayatdesk, page: () => KasirRiwayatDesktop()),
    GetPage(
      name: AppRoutes.kelolaprodukdashboard,
      page: () => KasirKelolaDashboard(),
    ),
    GetPage(name: AppRoutes.transactionDetail, page: () => DetailScreen()),
    GetPage(name: AppRoutes.lapordesk, page: () => LaporProdukDesk()),

    // ── Admin Desktop ──────────────────────────────────────────────────────
    GetPage(name: AppRoutes.dashboarddesk, page: () => DashboardPage()),
    GetPage(
      name: AppRoutes.kelolaprodukdesk,
      page: () => KelolaProdukDeskPage(),
    ),
    GetPage(name: AppRoutes.kelolabahandesk, page: () => BahanBakuScreen()),
    GetPage(name: AppRoutes.kelolaresepdesk, page: () => KelolaResepDeskPage()),
    GetPage(
      name: AppRoutes.monitoringuang,
      page: () => MonitoringKeuanganPage(),
    ),
    GetPage(name: AppRoutes.kelolaUserDesk, page: () => KelolaUserDeskPage()),
    GetPage(name: AppRoutes.laporanDesk, page: () => LaporanDeskPage()),
    // ── Admin Mobile ───────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.dashboardMob,
      page: () => DashboardMobileAdminPage(),
    ),
    GetPage(name: AppRoutes.kelolaProdukMob, page: () => ProductListPage()),
    GetPage(name: AppRoutes.kelolaBahanMob, page: () => BahanBakuListPage()),
    GetPage(
      name: AppRoutes.kelolaResepMob,
      page: () => KelolaResepMobilePage(),
    ),
    GetPage(
      name: AppRoutes.monitoringUangMob,
      page: () => MonitoringKeuanganMobilePage(),
    ),
    GetPage(
      name: AppRoutes.kelolaUserMob,
      page: () => KelolaUserMobilePage(),
    ),
    // GetPage(name: AppRoutes.qrisPayment, page: () => const QrisPaymentPage()),
    // ── Bakery ──────────────────────────────────────────────────────
    GetPage(name: AppRoutes.bakery, page: () => BakeryPage()),
    GetPage(
      name: AppRoutes.bakerydetail,
      page: () => BakeryDetailPage(resep: Get.arguments),
    ),
    GetPage(name: AppRoutes.bakerybahan, page: () => ManualBahanPage()),
  ];
}
