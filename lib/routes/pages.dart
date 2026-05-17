import 'package:get/get.dart';
import 'package:tugas_akhir/bindings/bindings.dart';
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
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';
import 'package:tugas_akhir/page/mobile/kalkulator_mobile.dart';
import 'package:tugas_akhir/page/mobile/keranjang_mobile.dart';
import 'package:tugas_akhir/page/mobile/sukses_mobile_page.dart';
import 'package:tugas_akhir/page/mobile/riwayat_mobile.dart';
import 'package:tugas_akhir/page/mobile/Kelolaproduk_mobile.dart';
import 'package:tugas_akhir/page/mobile/transaction_detail_mobile.dart';
 
import 'routes.dart';
 
class AppPages {
  static final pages = [
    // ── Login ──────────────────────────────────────────────────────────────
    GetPage(name: AppRoutes.login,      page: () => LoginPage(),        binding: AppBinding()),
    GetPage(name: AppRoutes.logindesk,  page: () => DesktopLoginPage(), binding: AppBinding()),
    GetPage(name: AppRoutes.mediaQuery, page: () => DashboardWrapper(), binding: AppBinding()),
 
    // ── Kasir Mobile ───────────────────────────────────────────────────────
    GetPage(name: AppRoutes.dashboardMobile,        page: () => KasirDashboardMobile(),     binding: AppBinding()),
    GetPage(name: AppRoutes.keranjang,              page: () => KeranjangMobilePage(),      binding: AppBinding()),
    GetPage(name: AppRoutes.kalkulator,             page: () => KalkulatorCashPage(),       binding: AppBinding()),
    GetPage(name: AppRoutes.sukses,                 page: () => SuksesMobilePage(),         binding: AppBinding()),
    GetPage(name: AppRoutes.riwayat,                page: () => RiwayatMobile(),            binding: AppBinding()),
    GetPage(name: AppRoutes.kelolaProduk,           page: () => KelolaProdukPage(),         binding: AppBinding()),
    GetPage(name: AppRoutes.transactionDetailMobile, page: () => TransactionDetailMobile(), binding: AppBinding()),
    GetPage(name: AppRoutes.kasirmobiledrawer, page: () => KasirMobileDrawer(), binding: AppBinding()),
 
    // ── Kasir Desktop ──────────────────────────────────────────────────────
    GetPage(name: AppRoutes.kasirboarddesk,        page: () => KasirDashboardDesktop(),    binding: AppBinding()),
    GetPage(name: AppRoutes.kasirbayar,            page: () => KasirPembayaranDesktop(),   binding: AppBinding()),
    GetPage(name: AppRoutes.kasirprint,            page: () => KasirSelesaiDesktop(),      binding: AppBinding()),
    GetPage(name: AppRoutes.riwayatdesk,           page: () => KasirRiwayatDesktop(),      binding: AppBinding()),
    GetPage(name: AppRoutes.kelolaprodukdashboard, page: () => KasirKelolaDashboard(),     binding: AppBinding()),
    GetPage(name: AppRoutes.transactionDetail,     page: () => DetailScreen(),             binding: AppBinding()),
 
    // ── Admin Desktop ──────────────────────────────────────────────────────
    GetPage(name: AppRoutes.kelolaprodukdesk, page: () => KelolaProdukDeskPage(), binding: AppBinding()),
    GetPage(name: AppRoutes.kelolabahandesk,  page: () => BahanBakuScreen(),      binding: AppBinding()),
    GetPage(name: AppRoutes.kelolaresepdesk,  page: () => KelolaResepDeskPage(),  binding: AppBinding()),
 
    // ── Admin Mobile ───────────────────────────────────────────────────────
    GetPage(name: AppRoutes.kelolaProdukMob, page: () => ProductListPage(),       binding: AppBinding()),
    GetPage(name: AppRoutes.kelolaBahanMob,  page: () => BahanBakuListPage(),     binding: AppBinding()),
    GetPage(name: AppRoutes.kelolaResepMob,  page: () => KelolaResepMobilePage(), binding: AppBinding()),
  ];
}