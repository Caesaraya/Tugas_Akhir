import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/widget/admin/produk/mobile/product_item_card.dart';
import 'package:tugas_akhir/widget/admin/produk/mobile/product_list_header.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';
import 'package:tugas_akhir/widget/admin/produk/mobile/product_pagination_footer.dart';
import 'package:tugas_akhir/widget/admin/dialogs/product/insert_product_dialog.dart';

class ProductListPage extends StatelessWidget {
  final controller = Get.find<ProductTableController>();
  final formatCurrency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MobileAdminDrawer(),
      backgroundColor: const Color(
        0xFFF8F9FA,
      ), // Latar belakang abu-abu terang sesuai gambar
      appBar: AppBar(
        title: const Text(
          'Kelola Produk',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          ProductListHeader(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              if (controller.paginatedList.isEmpty) {
                return const Center(child: Text('Data produk tidak ditemukan'));
              }

              return RefreshIndicator(
                color: Colors.black,
                onRefresh: () => controller.fetchData(),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  itemCount: controller.paginatedList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = controller.paginatedList[index];
                    return ProductItemCard(
                      product: product,
                      controller: controller,
                      formatCurrency: formatCurrency,
                    );
                  },
                ),
              );
            }),
          ),
          ProductPaginationFooter(controller: controller),
        ],
      ),
      // Tombol FAB Hitam di Pojok Kanan Bawah
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => Get.dialog(InsertProductDialog()),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
