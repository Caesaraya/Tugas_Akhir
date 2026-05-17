import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_item_card.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_list_header.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';
import 'package:tugas_akhir/widget/admin/bahan/mobile/bahan_baku_pagination_footer.dart';

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
        title: const Text(
          'Kelola Bahan Baku',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          BahanBakuListHeader(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.paginatedList.isEmpty) {
                return const Center(
                  child: Text('Data bahan baku tidak ditemukan'),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.fetchData(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.paginatedList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
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
    );
  }
}
