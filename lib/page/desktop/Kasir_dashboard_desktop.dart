import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/product_list_desktop.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/app_bar_desktop.dart';
import 'package:tugas_akhir/widget/widget desktop/dashboard/cart_panel.dart';

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
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    AppBarDesktop(
                      onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      color: Colors.white,
                      child: TabBar(
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        indicatorColor: Colors.orange,
                        labelColor: Colors.orange,
                        unselectedLabelColor: Colors.grey,
                        onTap: (index) {
                          controller.applyFilter(
                            category: controller.categories[index],
                          );
                        },
                        tabs: controller.categories
                            .map((jenis) => Tab(text: jenis.toUpperCase()))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: ProductListDesktop(
                        onProductTap: (product) =>
                            cartController.addToCart(product),
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(width: 1, color: Colors.grey[300]),
              const Expanded(flex: 3, child: CartPanel()),
            ],
          ),
        ),
      );
    });
  }
}
