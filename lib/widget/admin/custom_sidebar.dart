import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/admin/navigation_controller.dart';

class AdminSidebar extends StatelessWidget {
  AdminSidebar({super.key});

  final NavigationController navC = Get.find();
  final Color accentColor = Colors.orange; // Warna aksen untuk sidebar

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(color: accentColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/Logo_Rumah_Lezaa-removebg-preview.png',
                    height: 160,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Admin Panel',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildSidebarItem(
                    icon: Icons.shopping_bag,
                    title: 'Kelola Produk',
                    selected: navC.selectedIndex.value == 0,
                    onTap: () => navC.changePage(0, AppRoutes.kelolaprodukdesk),
                  ),
                  _buildSidebarItem(
                    icon: Icons.inventory,
                    title: 'Kelola Bahan',
                    selected: navC.selectedIndex.value == 1,
                    onTap: () => navC.changePage(1, AppRoutes.kelolabahandesk),
                  ),
                  _buildSidebarItem(
                    icon: Icons.restaurant_menu,
                    title: 'Kelola Resep',
                    selected: navC.selectedIndex.value == 2,
                    onTap: () => navC.changePage(2, AppRoutes.kelolaresepdesk),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: selected ? Colors.orange : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          color: selected ? Colors.orange : Colors.grey[900],
        ),
      ),
      selected: selected,
      selectedTileColor: const Color(0xFFE1F5FE),
      onTap: onTap,
    );
  }
}
