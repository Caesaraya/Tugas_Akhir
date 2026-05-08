import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
  }
}
