import 'package:get/get.dart';
import 'package:tugas_akhir/controller/mobile/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CartController(), permanent: true);
  }
}
