import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/dashboard/search_bar.dart';

class AppBarDesktop extends StatelessWidget {
  final String title;
  final bool showSearch;
  final VoidCallback? onMenuTap;

  const AppBarDesktop({
    super.key,
    this.title = 'Rumah Lezzaaa',
    this.showSearch = true,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Container(
    color: const Color(0xFFE89336),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              tooltip: 'Buka navigasi',
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (showSearch) ...[
            SizedBox(
              width: 250,
              child: MySearchBar(
                hintText: 'Cari produk...',
                onChanged: (value) => controller.applyFilter(query: value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
