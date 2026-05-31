import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

class MobileAdminDrawer extends StatelessWidget {
  const MobileAdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.black),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Rumah Lezzaaa',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Admin Panel', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.shopping_bag,
            title: 'Kelola Produk',
            routeName: AppRoutes.kelolaProdukMob,
            selected: currentRoute == AppRoutes.kelolaProdukMob,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.inventory,
            title: 'Kelola Bahan Baku',
            routeName: AppRoutes.kelolaBahanMob,
            selected: currentRoute == AppRoutes.kelolaBahanMob,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.restaurant_menu,
            title: 'Kelola Resep',
            routeName: AppRoutes.kelolaResepMob,
            selected: currentRoute == AppRoutes.kelolaResepMob,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Get.find<LoginController>().logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String routeName,
    required bool selected,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      selected: selected,
      onTap: () {
        Navigator.pop(context);
        if (Get.currentRoute != routeName) {
          Get.offNamed(routeName);
        }
      },
    );
  }
}
