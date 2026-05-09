import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/app_drawer.dart';
import '../routes/routes.dart';
import 'products/product_list_page.dart';
import 'riwayat_transaksi_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<MainPageController>(
      init: MainPageController(),
      builder: (controller) => Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
          title: Obx(() => Text(controller.getTitle())),
          backgroundColor: controller.getAppBarColor(),
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => controller.openDrawer(),
          ),
        ),
        drawer: const AppDrawerDummy(),
        body: Obx(() => controller.getCurrentPage()),
      ),
    );
  }
}

class MainPageController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var currentPage = AppRoutes.productList.obs;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void navigateToPage(String route) {
    currentPage.value = route;
    scaffoldKey.currentState?.closeDrawer();
  }

  Widget getCurrentPage() {
    switch (currentPage.value) {
      case AppRoutes.productList:
        return const ProductListPage();
      case AppRoutes.riwayatTransaksi:
        return const RiwayatTransaksiPage();
      default:
        return const ProductListPage();
    }
  }

  String getTitle() {
    switch (currentPage.value) {
      case AppRoutes.productList:
        return 'Kelola Produk';
      case AppRoutes.riwayatTransaksi:
        return 'Riwayat Transaksi';
      default:
        return 'Rumah Lezaa';
    }
  }

  Color getAppBarColor() {
    switch (currentPage.value) {
      case AppRoutes.productList:
        return Colors.blue.shade800;
      case AppRoutes.riwayatTransaksi:
        return const Color(0xFF8B4513);
      default:
        return Colors.blue.shade800;
    }
  }
}
