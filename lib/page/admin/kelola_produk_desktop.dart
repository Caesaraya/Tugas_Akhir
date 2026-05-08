// lib/views/kelola_produk_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/produk_admin_controller.dart';
import 'package:tugas_akhir/widget/admin/custom_drawer.dart';
import 'package:tugas_akhir/widget/admin/produk/empty_state.dart';
import 'package:tugas_akhir/widget/admin/produk/product_header_bar.dart';
import 'package:tugas_akhir/widget/admin/produk/tabel/product_table.dart';

class KelolaProdukDeskPage extends StatelessWidget {
  const KelolaProdukDeskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProductController());

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Rumah Lezzaaa'),
        backgroundColor: const Color(0xFF26C6DA),
      ),
      backgroundColor: const Color(0xFFF4F6F9),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search + tombol aksi ───────────────────
            ProductHeaderBar(ctrl: ctrl),
            const SizedBox(height: 20),

            // ── Tabel / loading / empty state ─────────
            Expanded(
              child: Obx(() {
                if (ctrl.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (ctrl.displayedProducts.isEmpty) {
                  return ProductEmptyState(ctrl: ctrl);
                }
                return ProductTable(ctrl: ctrl);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
