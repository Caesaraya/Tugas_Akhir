import 'package:get/get.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_bahan_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_produk_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/kelola_resep_desktop.dart';
import 'package:tugas_akhir/page/admin/desktop/monitoring_keuangan_desktop.dart';
import 'package:tugas_akhir/page/admin/mobile/bahanbaku/kelola_bahan_baku_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/produk/kelola_produk_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/resep/kelola_resep_mobile.dart';
import 'package:tugas_akhir/page/admin/mobile/uang/monitoring_keuangan_mobile.dart';
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
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';
import 'package:tugas_akhir/page/mobile/kalkulator_mobile.dart';
import 'package:tugas_akhir/page/mobile/keranjang_mobile.dart';
import 'package:tugas_akhir/page/mobile/sukses_mobile_page.dart';
import 'package:tugas_akhir/page/mobile/riwayat_mobile.dart';
import 'package:tugas_akhir/page/mobile/Kelolaproduk_mobile.dart';
import 'package:tugas_akhir/page/mobile/transaction_detail_mobile.dart';

import 'routes.dart';

// ... semua import Anda tetap sama ...

class AppPages {
  static final pages = [
    // ── Login ──────────────────────────────────────────────────────────────
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPage(), // Hapus properti binding
    ),
    GetPage(
      name: AppRoutes.logindesk,
      page: () => DesktopLoginPage(), // Hapus properti binding
    ),
    GetPage(
      name: AppRoutes.mediaQuery,
      page: () => DashboardWrapper(), // Hapus properti binding
    ),

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

    // ── Admin Desktop ──────────────────────────────────────────────────────
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

    // ── Admin Mobile ───────────────────────────────────────────────────────
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
  ];
}
