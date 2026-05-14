// lib/views/kelola_produk_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/widget/admin/custom_drawer.dart';
import 'package:tugas_akhir/widget/admin/dialogs/insert_product_dialog.dart';
import 'package:tugas_akhir/widget/admin/produk/product_table.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

class KelolaProdukDeskPage extends StatelessWidget {
  KelolaProdukDeskPage({super.key});
  final ctrl = Get.put(ProductTableController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Rumah Lezzaaa'),
        backgroundColor: const Color(0xFF26C6DA),
      ),
      backgroundColor: const Color(0xFFF4F6F9),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                TableSearchBar(
                  controller: ctrl.searchC,
                  hint: 'Cari produk...',
                ),
                SizedBox(width: 20),
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
    );
  }
}
