import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'product_card_desktop.dart';

class ProductListDesktop extends StatelessWidget {
  final Function(Product)? onProductTap;
  const ProductListDesktop({
    super.key,
    this.onProductTap,
  });
  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        );
      }
      if (controller.filteredList.isEmpty) {
        return const Center(
          child: Text(
            "Produk tidak ditemukan",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, 
          childAspectRatio: 0.72, 
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: controller.filteredList.length,
        itemBuilder: (context, index) {
          final product = controller.filteredList[index];
          return ProductCardDesktop(
            product: product,
            
            onTap: onProductTap != null
                ? () => onProductTap!(product)
                : null,
          );
        },
      );
    });
  }
}