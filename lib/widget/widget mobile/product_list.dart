import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_Mobile_controller.dart';
import 'product_card.dart';

class ProductList extends StatelessWidget {
  final String Function(int) tagBuilder;

  const ProductList({super.key, required this.tagBuilder});

  @override
  Widget build(BuildContext context) {
    // Ambil controller yang sudah di-inject
    final DashboardController controller = Get.put<DashboardController>(
      DashboardController(),
    );

    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator(color: Colors.brown)),
        );
      }

      // 1. GUNAKAN filteredList UNTUK CEK KOSONG
      if (controller.filteredList.isEmpty) {
        return const SizedBox(
          height: 200,
          child: Center(child: Text("Produk tidak ditemukan")),
        );
      }

      return SizedBox(
        height: 260,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          // 2. GUNAKAN filteredList UNTUK ITEM COUNT
          itemCount: controller.filteredList.length,
          clipBehavior: Clip.none,
          itemBuilder: (context, index) {
            return ProductCard(
              // 3. GUNAKAN filteredList UNTUK DATA PRODUK
              product: controller.filteredList[index],
              tag: tagBuilder(index),
            );
          },
        ),
      );
    });
  }
}