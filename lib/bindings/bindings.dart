import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/controller/admin/user_controller.dart';
import 'package:tugas_akhir/controller/detail_transaction_controller.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/controller/qris_controller.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/controller/product_controller.dart';
import 'package:tugas_akhir/controller/payment_controller.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/controller/kalkulator_controller.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // ── Admin controllers ─────────────────────────────────────────────────
    Get.lazyPut<ProductTableController>(
      () => ProductTableController(),
      fenix: true,
    );
    Get.lazyPut<BahanBakuTableController>(
      () => BahanBakuTableController(),
      fenix: true,
    );
    Get.lazyPut<ResepTableController>(
      () => ResepTableController(),
      fenix: true,
    );
    Get.lazyPut<KeuanganController>(() => KeuanganController(), fenix: true);
    Get.lazyPut<UserController>(() => UserController(), fenix: true);
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
      fenix: true,
    );

    // ── Core controllers ──────────────────────────────────────────────────
    Get.put<LoginController>(LoginController(), permanent: true);
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
    Get.lazyPut<KalkulatorController>(
      () => KalkulatorController(),
      fenix: true,
    );
    Get.lazyPut<RiwayatController>(() => RiwayatController(), fenix: true);
    Get.lazyPut<QrisController>(() => QrisController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    Get.lazyPut<KelolaProdukController>(
      () => KelolaProdukController(),
      fenix: true,
    );

    // ── Desktop controllers ───────────────────────────────────────────────
    Get.lazyPut<TransactionDetailController>(
      () => TransactionDetailController(),
      fenix: true,
    );
  }
}
