import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/routes.dart';

class AppDrawerDummy extends StatelessWidget {
  const AppDrawerDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.store,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rumah Lezaa',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Bakery POS System',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Menu Items
            _buildMenuItem(
              icon: Icons.inventory_2,
              title: 'Daftar Produk',
              subtitle: 'Kelola produk bakery',
              route: AppRoutes.productList,
              isSelected: Get.currentRoute == AppRoutes.productList,
            ),
            
            _buildMenuItem(
              icon: Icons.history,
              title: 'Riwayat Transaksi',
              subtitle: 'Lihat transaksi sebelumnya',
              route: AppRoutes.riwayatTransaksi,
              isSelected: Get.currentRoute == AppRoutes.riwayatTransaksi,
            ),
            
            const Divider(height: 32, color: Colors.grey),
            
            // Other Menu Items
            _buildMenuItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              subtitle: 'Halaman utama kasir',
              onTap: () {
                Get.back();
                _showComingSoonDialog(context);
              },
            ),
            
            _buildMenuItem(
              icon: Icons.shopping_cart,
              title: 'Keranjang',
              subtitle: 'Keranjang belanja',
              onTap: () {
                Get.back();
                _showComingSoonDialog(context);
              },
            ),
            
            const Divider(height: 32, color: Colors.grey),
            
            // Settings & Info
            _buildMenuItem(
              icon: Icons.settings,
              title: 'Pengaturan',
              subtitle: 'Konfigurasi aplikasi',
              onTap: () {
                Get.back();
                _showSettingsDialog(context);
              },
            ),
            
            _buildMenuItem(
              icon: Icons.info,
              title: 'Tentang',
              subtitle: 'Informasi aplikasi',
              onTap: () {
                Get.back();
                _showAboutDialog(context);
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? route,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8B4513).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isSelected 
            ? Border.all(color: const Color(0xFF8B4513), width: 1) 
            : null,
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected 
                ? const Color(0xFF8B4513) 
                : const Color(0xFF8B4513).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : const Color(0xFF8B4513),
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            color: isSelected ? const Color(0xFF8B4513) : Colors.black87,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: isSelected ? const Color(0xFF8B4513) : Colors.grey[600],
            fontSize: 12,
          ),
        ),
        trailing: route != null 
            ? Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isSelected ? const Color(0xFF8B4513) : Colors.grey[400],
              )
            : null,
        onTap: onTap ?? () {
          if (route != null) {
            Get.back(); // Close drawer first
            Get.toNamed(route); // Navigate to route
          }
        },
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title: Text('Bahasa'),
              subtitle: Text('Indonesia'),
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notifikasi'),
              subtitle: Text('Aktif'),
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Tema'),
              subtitle: Text('Terang'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Coming Soon'),
        content: const Text('Fitur ini akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rumah Lezaa Bakery POS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Versi: 1.0.0'),
            SizedBox(height: 8),
            Text(
              'Aplikasi Point of Sale khusus untuk bakery Rumah Lezaa. '
              'Membantu mengelola penjualan, produk, dan transaksi dengan mudah.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '© 2024 Rumah Lezaa',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
