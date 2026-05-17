import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/navbar_controller.dart';

class KasirMobileDrawer extends StatelessWidget {
  const KasirMobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final NavbarController navbarController = Get.put(NavbarController());

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
            _buildDrawerItem(
              context,
              icon: Icons.home,
              title: 'Beranda',
              index: 0,
              selected: navbarController.currentIndex.value == 0,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.shopping_cart,
              title: 'Keranjang',
              index: 1,
              selected: navbarController.currentIndex.value == 1,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.history,
              title: 'Riwayat',
              index: 2,
              selected: navbarController.currentIndex.value == 2,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.inventory,
              title: 'Kelola Produk',
              index: 3,
              selected: navbarController.currentIndex.value == 3,
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black87),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.pop(context);
                Get.offAllNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required bool selected,
  }) {
    final NavbarController navbarController = Get.find<NavbarController>();

    return ListTile(
      leading: Icon(
        icon,
        color: selected ? const Color(0xFFE89336) : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? const Color(0xFFE89336) : Colors.black87,
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
      selected: selected,
      selectedTileColor: const Color(0xFFE89336).withOpacity(0.12),
      onTap: () {
        Navigator.pop(context);
        navbarController.changePage(index);
      },
    );
  }
}
