import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard_bakery/produk_card.dart';

class BakeryResepGrid extends StatelessWidget {
  final BakeryController ctrl;
  const BakeryResepGrid({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (ctrl.filteredResep.isEmpty) {
        return const Center(
          child: Text(
            'Resep tidak ditemukan',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: ctrl.filteredResep.length,
        itemBuilder: (_, i) {
          final resep = ctrl.filteredResep[i];
          return BakeryResepCard(
            resep: resep,
            onTap: () => ctrl.navigateToDetail(resep),
          );
        },
      );
    });
  }
}
