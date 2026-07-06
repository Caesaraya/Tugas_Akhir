import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../../controller/admin/navigation_controller.dart';

class AdminSidebar extends StatelessWidget {
  AdminSidebar({super.key});

  final NavigationController navC = Get.find();

  // Skema Warna Sesuai Gambar Referensi
  final Color activeBgColor = const Color(
    0xFF1E1E1E,
  ); // Hitam gelap untuk background menu aktif
  final Color inactiveTextColor = const Color(
    0xFF616161,
  ); // Abu-abu gelap untuk teks tidak aktif
  final Color categoryTextColor = const Color(
    0xFF9E9E9E,
  ); // Abu-abu terang untuk header kategori (MENU/SISTEM)

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Obx(
        () => Column(
          children: [
            // --- HEADER SIDEBAR ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              color: Colors.white,
              child: Row(
                children: [
                  // Logo Kotak Hitam "RL" di pojok kiri atas
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'RL',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Rumah Lezaa',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Bakery Management',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFECEFF1)),

            // --- KONTEN MENU UTAMA ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                children: [
                  // Sub-header MENU
                  _buildCategoryHeader('MENU'),

                  const SizedBox(height: 8),

                  _buildSidebarItem(
                    icon: Icons.home_outlined,
                    title: 'Dashboard',
                    selected: navC.selectedIndex.value == 0,
                    onTap: () => navC.changePage(0, AppRoutes.dashboarddesk),
                  ),
                  const SizedBox(height: 8),

                  _buildSidebarItem(
                    icon: Icons.shopping_bag_outlined,
                    title: 'Kelola Produk',
                    selected: navC.selectedIndex.value == 1,
                    onTap: () => navC.changePage(1, AppRoutes.kelolaprodukdesk),
                  ),
                  const SizedBox(height: 8),

                  _buildSidebarItem(
                    icon: Icons
                        .opacity_outlined, // Ikon tetesan air untuk Kelola Bahan
                    title: 'Kelola Bahan',
                    selected: navC.selectedIndex.value == 2,
                    onTap: () => navC.changePage(2, AppRoutes.kelolabahandesk),
                  ),
                  const SizedBox(height: 8),

                  _buildSidebarItem(
                    icon: Icons
                        .menu_book_outlined, // Ikon buku untuk Kelola Resep
                    title: 'Kelola Resep',
                    selected: navC.selectedIndex.value == 3,
                    onTap: () => navC.changePage(3, AppRoutes.kelolaresepdesk),
                  ),
                  const SizedBox(height: 8),
                  _buildSidebarItem(
                    icon: Icons
                        .monetization_on_outlined, // Ikon tetesan air untuk Kelola Bahan
                    title: 'Monitoring Keuangan',
                    selected: navC.selectedIndex.value == 4,
                    onTap: () => navC.changePage(4, AppRoutes.monitoringuang),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFECEFF1)),

            // --- TOMBOL LOGOUT ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                horizontalTitleGap: 12,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Color(
                    0xFFC62828,
                  ), // Warna merah maroon/bata redup sesuai gambar
                  size: 22,
                ),
                title: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color(0xFFC62828),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Get.find<LoginController>().logout();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Pembantu untuk Teks Header Kategori (MENU / SISTEM)
  Widget _buildCategoryHeader(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 12),
      child: Text(
        text,
        style: TextStyle(
          color: categoryTextColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  // Widget Pembantu Item List Menu Sidebar
  Widget _buildSidebarItem({
    required IconData icon,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        // Efek Melayang (Floating) dengan background hitam pekat jika dipilih
        color: selected ? activeBgColor : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        horizontalTitleGap: 12,
        visualDensity: const VisualDensity(vertical: -1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Icon(
          icon,
          color: selected ? Colors.white : inactiveTextColor,
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : inactiveTextColor,
            fontSize: 15,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
