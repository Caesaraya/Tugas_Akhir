// lib/views/screens/bahan_baku/bahan_baku_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/widget/admin/bahan/bahan_baku_table.dart';

import 'package:tugas_akhir/widget/admin/custom_drawer.dart';
import 'package:tugas_akhir/widget/admin/dialogs/bahan/insert_bahan_baku_dialog.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

class BahanBakuScreen extends StatelessWidget {
  BahanBakuScreen({super.key}) {
    Get.find<NavigationController>().selectedIndex.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    // Pastikan controller teregistrasi (jika belum di-inject global)
    final ctrl = Get.find<BahanBakuTableController>();

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
                        title: 'Insert Bahan',
                        icon: Icons.add,
                        color: Colors.cyan,
                        onTap: () {
                          ctrl.clearForm();
                          Get.dialog(InsertBahanBakuDialog());
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
                      child: BahanBakuTable(),
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
