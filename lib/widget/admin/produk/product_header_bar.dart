// lib/views/widgets/product/product_header_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/produk_admin_controller.dart';
import 'package:tugas_akhir/widget/admin/produk/product_action_button.dart';
import 'package:tugas_akhir/widget/admin/produk/product_searchbar.dart';
import 'package:tugas_akhir/widget/admin/produk/refresh_button.dart';

class ProductHeaderBar extends StatelessWidget {
  const ProductHeaderBar({super.key, required this.ctrl});

  final ProductController ctrl;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Search Field
        ProductSearchBar(ctrl: ctrl),

        // Action Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Insert Data
            ProductActionButton(
              label: 'Insert data',
              icon: Icons.add,
              color: const Color(0xFF26C6DA),
              onPressed: ctrl.showCreateDialog,
            ),
            const SizedBox(width: 10),

            // Sortir Stok Habis (warna berubah saat aktif)
            Obx(
              () => ProductActionButton(
                label: 'Sortir Stok Habis',
                icon: Icons.filter_list,
                color: ctrl.isFilteringOutOfStock.value
                    ? const Color(0xFFFF6F00)
                    : const Color(0xFFFFC107),
                onPressed: ctrl.toggleOutOfStockFilter,
              ),
            ),
            const SizedBox(width: 10),

            // Refresh
            ProductRefreshButton(onPressed: ctrl.fetchProducts),
          ],
        ),
      ],
    );
  }
}
