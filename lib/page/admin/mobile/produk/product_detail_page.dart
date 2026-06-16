import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/widget/admin/produk/mobile/product_detail_widgets.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final controller = Get.find<ProductTableController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      // Menggunakan Obx agar halaman detail memantau perubahan data terbaru di controller secara real-time
      body: Obx(() {
        // Cari data ter-update dari originalList di controller berdasarkan id produk
        final latestProduct = controller.originalList.firstWhere(
          (p) => p.id == product.id,
          orElse: () => product, // Fallback jika tidak ditemukan
        );

        return Column(
          children: [
            ProductDetailBody(product: latestProduct, currency: currency),
            ProductDetailActions(
              product: latestProduct,
              controller: controller,
            ),
          ],
        );
      }),
    );
  }
}
