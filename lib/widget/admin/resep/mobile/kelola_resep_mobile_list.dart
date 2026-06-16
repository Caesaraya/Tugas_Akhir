import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/resep_table_controller.dart';
import 'package:tugas_akhir/widget/admin/resep/mobile/resep_item_card.dart';

class KelolaResepMobileList extends StatelessWidget {
  final ResepTableController controller;

  const KelolaResepMobileList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.black),
        );
      }

      if (controller.paginatedList.isEmpty) {
        return const Center(
          child: Text(
            'Data resep tidak ditemukan',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return RefreshIndicator(
        color: Colors.black,
        onRefresh: () => controller.fetchData(),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: controller.paginatedList.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = controller.paginatedList[index];
            return ResepItemCard(
              resep: item,
              onTap: () => controller.goToDetailMobile(item),
            );
          },
        ),
      );
    });
  }
}
