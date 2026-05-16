import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/admin/navigation_controller.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final NavigationController navC = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Admin Panel 🚀",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),

            // Menu Kelola Produk
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Kelola Produk"),
              selected: navC.selectedIndex.value == 0,
              onTap: () {
                navC.changePage(0, AppRoutes.kelolaprodukdesk);
              },
            ),

            // Menu Kelola Bahan
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text("Kelola Bahan"),
              selected: navC.selectedIndex.value == 1,
              onTap: () {
                navC.changePage(1, AppRoutes.kelolabahandesk);
              },
            ),

            // Menu Kelola Resep
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text("Kelola Resep"),
              selected: navC.selectedIndex.value == 2,
              onTap: () {
                navC.changePage(2, AppRoutes.kelolaresepdesk);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
