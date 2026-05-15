import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProductTableController());
    Get.put(BahanBakuTableController());
    Get.put(ResepTableController());
    Get.lazyPut<NavigationController>(
      () => NavigationController(),
      fenix: true,
    );
  }
}
