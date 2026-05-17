import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/controller/detail_transaction_controller.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/controller/product_controller.dart';
import 'package:tugas_akhir/controller/payment_controller.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/controller/kalkulator_controller.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductTableController());
    Get.put(BahanBakuTableController());
    Get.put(LoginController());
    Get.put(ResepTableController());
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
      fenix: true,
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Admin / table controllers
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
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
      fenix: true,
    );

    // Core app controllers
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<RiwayatController>(() => RiwayatController(), fenix: true);
    Get.lazyPut<ProductController>(() => ProductController(), fenix: true);
    Get.lazyPut<PaymentController>(() => PaymentController(), fenix: true);
    Get.lazyPut<KelolaProdukController>(
      () => KelolaProdukController(),
      fenix: true,
    );
    Get.lazyPut<KalkulatorController>(
      () => KalkulatorController(),
      fenix: true,
    );
    Get.lazyPut<CartController>(() => CartController(), fenix: true);

    // Desktop specific controllers
    Get.lazyPut<PaymentController>(
      () => PaymentController(),
      fenix: true,
    );
    Get.lazyPut<TransactionDetailController>(
      () => TransactionDetailController(),
      fenix: true,
    );

    // Dashboard
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<KasirMobileDrawer>(() => KasirMobileDrawer(), fenix: true);
  }
}
