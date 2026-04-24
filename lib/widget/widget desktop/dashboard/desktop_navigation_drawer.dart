import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';

class DesktopNavigationDrawer extends StatelessWidget {
  final String? currentRoute;

  const DesktopNavigationDrawer({super.key, this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.orange),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Text(
                  'Menu Navigasi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pilih halaman desktop',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            context,
            icon: Icons.home,
            label: 'Dashboard',
            route: AppRoutes.kasirboarddesk,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.history,
            label: 'Riwayat',
            route: AppRoutes.riwayatdesk,
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.close, color: Colors.grey),
            title: const Text('Tutup menu'),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    final selected = currentRoute == route;

    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(label),
      selected: selected,
      selectedTileColor: Colors.orange.withOpacity(0.1),
      onTap: () {
        Navigator.of(context).pop();
        if (!selected) {
          Get.offAllNamed(route);
        }
      },
    );
  }
}
