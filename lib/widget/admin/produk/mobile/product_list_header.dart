import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/widget/admin/dialogs/product/insert_product_dialog.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

class ProductListHeader extends StatelessWidget {
  final ProductTableController controller;

  const ProductListHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TableSearchBar(
              controller: controller.searchC,
              hint: 'Cari produk...',
            ),
          ),
          const SizedBox(width: 12),
          ToolbarButton(
            icon: Icons.add,
            color: const Color(0xFF5D4037),
            onTap: () => Get.dialog(InsertProductDialog()),
          ),
        ],
      ),
    );
  }
}
