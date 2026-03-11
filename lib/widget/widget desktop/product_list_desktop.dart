import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_Mobile_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'product_card_desktop.dart';

class ProductListDesktop extends StatelessWidget {
  final String Function(int) tagBuilder;
  final Function(Product)? onProductTap;

  const ProductListDesktop({
    super.key,
    required this.tagBuilder,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.brown),
        );
      }

      if (controller.filteredList.isEmpty) {
        return const Center(child: Text("Produk tidak ditemukan"));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Sesuaikan jumlah kolom
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: controller.filteredList.length,
        itemBuilder: (context, index) {
          return ProductCardDesktop(
            product: controller.filteredList[index],
            tag: tagBuilder(index),
            onTap: onProductTap != null
                ? () => onProductTap!(controller.filteredList[index])
                : null,
          );
        },
      );
    });
  }
}
