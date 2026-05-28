// Widget reusable untuk summary cards produk
// Letakkan di antara subtitle dan toolbar row pada KelolaProdukDeskPage

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/widget/admin/bahan/summary_card.dart'; // sesuaikan path

class ProductSummaryCards extends StatelessWidget {
  const ProductSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProductTableController>();

    return Obx(() {
      // Hitung statistik dari originalList (seluruh data, bukan yang difilter)
      final allProducts = ctrl.originalList;

      final totalProduk = allProducts.length;
      final totalStok = allProducts.fold<int>(0, (sum, p) => sum + p.stock);
      final stokHabis = allProducts.where((p) => p.stock <= 0).length;

      return Row(
        children: [
          // Card 1 – Total Produk
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

          // Card 2 – Total Stok
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

          // Card 3 – Stok Habis
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
    });
  }
}
