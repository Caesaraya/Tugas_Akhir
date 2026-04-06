import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/dashboard_Mobile_controller.dart';

class AppBarDesktop extends StatelessWidget {
  const AppBarDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Container(
      color: Colors.orange,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.white),
          const SizedBox(width: 10),
          const Text(
            "Rumah Lezzaaa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          /// SEARCH
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
                hintText: "Cari Produk",
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
