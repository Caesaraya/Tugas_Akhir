import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/dashboard_Mobile_controller.dart';

class AppBarDesktop extends StatelessWidget {
  final String title;
  final bool showSearch;

  const AppBarDesktop({
    super.key,
    this.title = 'Rumah Lezzaaa',
    this.showSearch = true,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.put(DashboardController());

    return Container(
      color: Colors.orange,
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
            Container(
              width: 250,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                onChanged: (value) => controller.filterProducts(value),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
