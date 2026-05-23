// lib/views/kelola_produk_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
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
      backgroundColor: const Color(0xFFFAFAFA), // Disamakan dengan Bahan Baku
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSidebar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(
                32.0,
              ), // Padding disamakan menjadi 32
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- JUDUL & SUBTITLE HALAMAN ---
                  const Text(
                    'Kelola Produk',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Manajemen data produk, harga jual, dan stok kue',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),

                  // --- TOOLBAR ROW ---
                  Row(
                    children: [
                      const Text(
                        "Daftar Produk",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      TableSearchBar(
                        controller: ctrl.searchC,
                        hint: 'Cari produk...',
                      ),
                      const SizedBox(width: 12),
                      ToolbarButton(
                        title: 'Insert Product',
                        icon: Icons.add_rounded,
                        color: const Color(
                          0xFF1E1E1E,
                        ), // Menggunakan Hitam Tema Utama
                        onTap: () {
                          Get.dialog(InsertProductDialog());
                        },
                      ),
                      const SizedBox(width: 12),
                      ToolbarButton(
                        title: "Sortir Stok Habis",
                        icon: Icons.sort_rounded,
                        color: Colors.grey.shade700,
                        onTap: () {
                          ctrl.toggleFilterStockHabis();
                        },
                      ),
                      const SizedBox(width: 12),
                      ToolbarButton(
                        title: "",
                        icon: Icons.refresh_outlined,
                        color: Colors.grey.shade400,
                        onTap: () {
                          ctrl.refreshData();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- TABEL PRODUK ---
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: ProductTable(),
                      ),
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
