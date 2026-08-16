// lib/views/kelola_produk_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/dialogs/product/insert_product_dialog.dart';
import 'package:tugas_akhir/widget/admin/produk/product_table.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';
import 'package:tugas_akhir/widget/admin/bahan/summary_card.dart';

class KelolaProdukDeskPage extends StatelessWidget {
  KelolaProdukDeskPage({super.key});

  final ctrl = Get.find<ProductTableController>();

  @override
  Widget build(BuildContext context) {
    // Pindahkan mutasi Rx ke luar fase build agar tidak bentrok dengan
    // Obx di AdminSidebar yang sedang dibangun bersamaan.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NavigationController>().selectedIndex.value = 1;
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSidebar(),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(() {
                      final allProducts = ctrl.originalList;
                      final totalProduk = allProducts.length;
                      final totalStok = allProducts.fold<int>(
                        0,
                        (sum, p) => sum + p.stock,
                      );
                      final stokHabis = allProducts
                          .where((p) => p.stock <= 0)
                          .length;

                      return Row(
                        children: [
                          SummaryCard(
                            title: 'Total Produk',
                            value: '$totalProduk',
                            subtitle: 'Jenis produk terdaftar',
                            subtitleColor: Colors.blue.shade600,
                            trailingGraph: Icon(
                              Icons.inventory_2_outlined,
                              size: 40,
                              color: Colors.blue.shade100,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SummaryCard(
                            title: 'Total Stok',
                            value: '$totalStok',
                            subtitle: 'Unit tersedia di seluruh produk',
                            subtitleColor: Colors.green.shade600,
                            trailingGraph: Icon(
                              Icons.layers_outlined,
                              size: 40,
                              color: Colors.green.shade100,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SummaryCard(
                            title: 'Stok Habis',
                            value: '$stokHabis',
                            subtitle: stokHabis > 0
                                ? '$stokHabis produk perlu diisi ulang'
                                : 'Semua produk tersedia',
                            subtitleColor: stokHabis > 0
                                ? Colors.red.shade600
                                : Colors.green.shade600,
                            trailingGraph: Icon(
                              stokHabis > 0
                                  ? Icons.warning_amber_rounded
                                  : Icons.check_circle_outline,
                              size: 40,
                              color: stokHabis > 0
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
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
                          color: AppColors.black,
                          onTap: () {
                            Get.dialog(InsertProductDialog());
                          },
                        ),
                        const SizedBox(width: 12),
                        ToolbarButton(
                          title: "Sortir Stok Habis",
                          icon: Icons.sort_rounded,
                          color: AppColors.black,
                          onTap: () {
                            ctrl.toggleFilterStockHabis();
                          },
                        ),
                        const SizedBox(width: 12),
                        ToolbarButton(
                          title: "",
                          icon: Icons.refresh_outlined,
                          color: AppColors.black,
                          onTap: () {
                            ctrl.fetchData();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ProductTable(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
