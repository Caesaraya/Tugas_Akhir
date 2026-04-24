import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/dashboard_Mobile_controller.dart';
import '../../controller/cart_controller.dart';
import '../../widget/widget desktop/dashboard/product_list_desktop.dart';
import '../../widget/widget desktop/dashboard/app_bar_desktop.dart';
import '../../widget/widget desktop/dashboard/cart_panel_desktop.dart';
import '../../widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import '../../routes/routes.dart';

class KasirDashboardDesktop extends StatelessWidget {
  KasirDashboardDesktop({super.key});

  // Tambahkan controller
  final DashboardController controller = Get.put(DashboardController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: const DesktopNavigationDrawer(
          currentRoute: AppRoutes.kasirboarddesk,
        ),
        body: Row(
          children: [
            /// PANEL PRODUK
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  /// APPBAR
                  AppBarDesktop(),

                  /// TAB KATEGORI
                  Container(
                    color: Colors.grey[200],
                    child: const TabBar(
                      labelColor: Colors.orange,
                      unselectedLabelColor: Colors.black54,
                      indicatorColor: Colors.orange,
                      tabs: [
                        Tab(text: "Semua"),
                        Tab(text: "Favorit"),
                        Tab(text: "Promo"),
                        Tab(text: "Kosong"),
                      ],
                    ),
                  ),

                  /// LIST PRODUK
                  Expanded(
                    child: ProductListDesktop(
                      tagBuilder: (index) => index == 0 ? "Hot Item" : "New",
                      onProductTap: cartController.addToCart,
                    ),
                  ),
                ],
              ),
            ),

            /// PANEL KERANJANG
            const CartPanelDesktop(),
          ],
        ),
      ),
    );
  }
}
