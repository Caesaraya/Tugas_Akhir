import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_controller.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/produk_admin_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
    Get.put(ProductAdminController());
    Get.put(BahanBakuController());
  }
}
