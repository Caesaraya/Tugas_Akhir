import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';
import 'package:tugas_akhir/widget/admin/produk/mobile/product_item_card.dart';
import 'package:tugas_akhir/widget/admin/produk/mobile/product_list_header.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';
import 'package:tugas_akhir/widget/admin/produk/mobile/product_pagination_footer.dart';
import 'package:tugas_akhir/widget/admin/dialogs/product/insert_product_dialog.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';

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
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // Mengganti title teks menjadi Search Bar yang menyatu dengan AppBar
        title: TableSearchBar(
          controller: controller.searchC,
          hint: 'Cari nama produk...',
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle:
            false, // Diubah ke false agar search bar mengambil ruang maksimal setelah drawer icon
        titleSpacing:
            0, // Memaksimalkan kerapatan horizontal search bar dengan tombol menu
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () => Get.dialog(InsertProductDialog()),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
