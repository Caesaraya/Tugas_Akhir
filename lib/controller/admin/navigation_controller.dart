import 'package:get/get.dart';

class NavigationController extends GetxController {
  final selectedIndex = 0.obs;

  void changePage(int index, String routeName) {
    // 1. Cegah eksekusi jika menekan menu yang sedang aktif
    if (selectedIndex.value == index) return;

    // 2. Ubah state UI sidebar
    selectedIndex.value = index;

    // 3. Tunda eksekusi navigasi ke frame berikutnya agar tidak bentrok
    // dengan proses build dari Obx Sidebar
    Future.microtask(() {
      Get.offNamed(routeName);
    });
  }
}
