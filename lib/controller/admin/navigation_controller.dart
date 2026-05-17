import 'package:get/get.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;

  void changePage(int index, String routeName) {
    selectedIndex.value = index;

    // Menggunakan Get.offAllNamed agar tumpukan (stack) navigasi bersih
    // Ini membantu status 'selected' tetap konsisten saat berpindah
    Get.offAllNamed(routeName);
  }
}
