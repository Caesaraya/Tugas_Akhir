import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_item_card.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_list_header.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_pagination_footer.dart';
import 'package:tugas_akhir/widget/admin/dialogs/bahan/insert_bahan_baku_dialog.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';

class BahanBakuListPage extends StatelessWidget {
  final controller = Get.find<BahanBakuTableController>();
  final formatCurrency = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  BahanBakuListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MobileAdminDrawer(),
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        // Mengganti judul teks lama dengan elemen Search Bar langsung
        title: TableSearchBar(
          controller: controller.searchC,
          hint: 'Cari bahan baku...',
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // BahanBakuListHeader disesuaikan di file internalnya untuk membuang search bar lamanya
          // BahanBakuListHeader(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }

              if (controller.paginatedList.isEmpty) {
                return const Center(
                  child: Text('Data bahan baku tidak ditemukan'),
                );
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
                    final item = controller.paginatedList[index];
                    return BahanBakuItemCard(
                      item: item,
                      controller: controller,
                      formatCurrency: formatCurrency,
                    );
                  },
                ),
              );
            }),
          ),
          BahanBakuPaginationFooter(controller: controller),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => Get.dialog(InsertBahanBakuDialog()),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
