import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dashboard_Mobile_controller.dart';
import 'product_card.dart';

class ProductList extends StatelessWidget {
  final String Function(int) tagBuilder;

  const ProductList({super.key, required this.tagBuilder});

  @override
  Widget build(BuildContext context) {
    final DashboardController controller = Get.find<DashboardController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(color: Colors.brown),
          ),
        );
      }

      if (controller.productList.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(child: Text("Produk sedang kosong")),
        );
      }

      return SizedBox(
        height: 260, // Sesuaikan dengan tinggi ProductCard kamu
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.productList.length,
          clipBehavior: Clip.none, // Agar shadow kartu tidak terpotong
          itemBuilder: (context, index) {
            return ProductCard(
              product: controller.productList[index],
              tag: tagBuilder(index),
            );
          },
        ),
      );
    });
  }
}