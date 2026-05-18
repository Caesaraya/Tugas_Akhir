import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard/button.dart';
import 'package:tugas_akhir/widget/widget%20mobile/dashboard/product_card.dart';

class DashboardProductGrid extends StatelessWidget {
  final DashboardController ctrl;

  const DashboardProductGrid({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ctrl.displayedList.isEmpty) {
        return const Center(child: Text('Produk tidak ditemukan'));
      }
      return Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.60,
            ),
            itemCount: ctrl.displayedList.length,
            itemBuilder: (context, index) {
              final product = ctrl.displayedList[index];
              return ProductCard(product: product, tag: product.jenis);
            },
          ),
          const SizedBox(height: 16),
          LoadMoreButton(ctrl: ctrl),
        ],
      );
    });
  }
}
