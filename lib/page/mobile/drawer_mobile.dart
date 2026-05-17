import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/widget/widget mobile/drawer/drawer_item.dart';

class KasirMobileDrawer extends StatelessWidget {
  const KasirMobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final KasirMobileDrawer kasirMobileDrawer = Get.put(KasirMobileDrawer());

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFFF8D8A2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/Logo_Rumah_Lezaa-removebg-preview.png',
                    height: 64,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Rumah Lezzaaa',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manajemen Inventori & Stok',
                    style: TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
            DrawerItem(
              icon: Icons.home,
              title: 'Beranda',
              route: AppRoutes.dashboardMobile,
            ),
            DrawerItem(
              icon: Icons.history,
              title: 'Riwayat',
              route: AppRoutes.riwayat,
            ),
            DrawerItem(
              icon: Icons.inventory,
              title: 'Kelola Produk',
              route: AppRoutes.kelolaProduk,
            ),
            const Spacer(),
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
      ),
    );
  }
}
