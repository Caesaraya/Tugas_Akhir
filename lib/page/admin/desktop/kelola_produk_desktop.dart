// lib/views/kelola_produk_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/widget/admin/custom_drawer.dart';
import 'package:tugas_akhir/widget/admin/dialogs/product/insert_product_dialog.dart';
import 'package:tugas_akhir/widget/admin/produk/product_table.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

class KelolaProdukDeskPage extends StatelessWidget {
  KelolaProdukDeskPage({super.key}) {
    Get.find<NavigationController>().selectedIndex.value = 0;
  }
  final ctrl = Get.find<ProductTableController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      TableSearchBar(
                        controller: ctrl.searchC,
                        hint: 'Cari produk...',
                      ),
                      const SizedBox(width: 20),
                      ToolbarButton(
                        title: 'Insert Product',
                        icon: Icons.add,
                        color: Colors.cyan,
                        onTap: () {
                          Get.dialog(InsertProductDialog());
                        },
                      ),
                      const SizedBox(width: 12),
                      ToolbarButton(
                        title: "Sortir Stok Habis",
                        icon: Icons.sort,
                        color: Colors.orange,
                        onTap: () {
                          ctrl.toggleFilterStockHabis();
                        },
                      ),
                      const SizedBox(width: 12),
                      ToolbarButton(
                        title: "",
                        icon: Icons.refresh,
                        color: Colors.green,
                        onTap: () {
                          ctrl.refreshData();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: ProductTable(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
