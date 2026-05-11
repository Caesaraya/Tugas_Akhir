import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/widget%20desktop/dashboard/desktop_navigation_drawer.dart';
import '../../controller/mobile/dashboard_Mobile_controller.dart';
import '../../controller/mobile/cart_controller.dart'; // Menggunakan controller kamu
import '../../widget/widget desktop/dashboard/product_list_desktop.dart';
import '../../widget/widget desktop/dashboard/app_bar_desktop.dart';
import '../../widget/widget desktop/dashboard/cart_panel_desktop.dart';

class KasirDashboardDesktop extends StatelessWidget {
  KasirDashboardDesktop({super.key});

  final DashboardController controller = Get.put(DashboardController());
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      return DefaultTabController(
        length: controller.categories.length,
        child: Scaffold(
          key: scaffoldKey,
          drawer: const DesktopNavigationDrawer(),
          body: Row(
            children: [
              /// BAGIAN KIRI: Katalog Produk (Dibuat lebih lebar)
              Expanded(
                flex: 7, // Memberi ruang lebih besar untuk produk
                child: Column(
                  children: [
                    AppBarDesktop(
                      onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
                      
                    ),

                    /// TAB KATEGORI: Bisa digeser ke kanan (Scrollable)
                    Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.white,
                      child: TabBar(
                        isScrollable: true, // SOLUSI: Agar jenis bisa digeser ke kanan
                        tabAlignment: TabAlignment.start,
                        indicatorColor: Colors.orange,
                        labelColor: Colors.orange,
                        unselectedLabelColor: Colors.grey,
                        onTap: (index) {
                          controller.applyFilter(category: controller.categories[index]);
                        },
                        tabs: controller.categories
                            .map((jenis) => Tab(text: jenis.toUpperCase()))
                            .toList(),
                      ),
                    ),

                    /// LIST PRODUK: Ukuran tetap mungil
                    Expanded(
                      child: ProductListDesktop(
                        onProductTap: (product) => cartController.addToCart(product),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(width: 1, color: Colors.grey[300]),
              const Expanded(
                flex: 3, // Panel keranjang tetap di posisinya
                child: CartPanelDesktop(),
              ),
            ],
          ),
        ),
      );
    });
  }
}