import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/admin/laporan_controller.dart';

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
            icon: Icons.home_outlined,
            title: 'Dashboard',
            routeName: AppRoutes.dashboardMob,
            selected: currentRoute == AppRoutes.kelolaProdukMob,
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
          // ← TAMBAHAN BARU: Laporan
          // _buildDrawerItem(
          //   context,
          //   icon: Icons.report_gmailerrorred_outlined,
          //   title: 'Laporan',
          //   routeName: AppRoutes.laporanMob,
          //   selected: currentRoute == AppRoutes.laporanMob,
          //   trailing: Obx(() {
          //     final count = LaporanController.to.pendingCount;
          //     if (count == 0) return const SizedBox.shrink();
          //     return Container(
          //       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          //       decoration: BoxDecoration(
          //         color: const Color(0xFFC62828),
          //         borderRadius: BorderRadius.circular(20),
          //       ),
          //       child: Text(
          //         count.toString(),
          //         style: const TextStyle(
          //           color: Colors.white,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 12,
          //         ),
          //       ),
          //     );
          //   }),
          // ),
          _buildDrawerItem(
            context,
            icon: Icons
                .monetization_on_outlined, // Ikon tetesan air untuk Kelola Bahan
            title: 'Monitoring Keuangan',
            selected: currentRoute == AppRoutes.monitoringUangMob,
            routeName: AppRoutes.monitoringUangMob,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.people_alt_outlined, // ← TAMBAHAN BARU
            title: 'Kelola User',
            routeName: AppRoutes.kelolaUserMob,
            selected: currentRoute == AppRoutes.kelolaUserMob,
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
    Widget? trailing, // ← TAMBAHAN BARU: untuk badge
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
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
