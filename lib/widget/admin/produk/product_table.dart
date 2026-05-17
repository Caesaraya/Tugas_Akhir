import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/widget/admin/table/table_header_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_pagination.dart';
import 'package:tugas_akhir/widget/admin/table/table_row_cell.dart';

import '../../../controller/admin/product_table_controller.dart';
import '../../admin/table/table_action_button.dart';
// Jika URL image dari API hanya relative path (misal: /storage/img.jpg),
// jangan lupa import ApiService dan tambahkan baseUrl-nya di Image.network
// import '../../../api_service.dart';

class ProductTable extends StatelessWidget {
  ProductTable({super.key});

  final ctrl = Get.put(ProductTableController());
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: const [
              TableHeaderCell(title: 'ID', width: 60),
              TableHeaderCell(title: 'Nama', width: 150),
              TableHeaderCell(title: 'Harga', width: 100),
              TableHeaderCell(title: 'Diskon', width: 60),
              TableHeaderCell(title: 'Harga Final', width: 100),
              TableHeaderCell(title: 'Stock', width: 60),
              TableHeaderCell(title: 'Jenis', width: 90),
              TableHeaderCell(title: 'Satuan', width: 60),
              TableHeaderCell(title: 'Barcode', width: 90),
              TableHeaderCell(
                title: 'Image',
                width: 70,
              ), // Width kolom biarkan 70
              TableHeaderCell(title: 'Aksi', width: 100),
            ],
          ),

          ...ctrl.paginatedList.map((item) {
            return Row(
              children: [
                TableRowCell(text: item.id.toString(), width: 60),
                TableRowCell(text: item.name, width: 150),
                TableRowCell(
                  text: currencyFormatter.format(item.price),
                  width: 100,
                ),
                TableRowCell(text: '${item.discount}%', width: 60),
                TableRowCell(
                  text: currencyFormatter.format(item.priceAfterDiscount),
                  width: 100,
                ),
                TableRowCell(text: item.stock.toString(), width: 60),
                TableRowCell(text: item.jenis, width: 90),
                TableRowCell(text: item.satuan, width: 60),
                TableRowCell(text: item.barcode, width: 90),

                // ===== UPDATE DI SINI =====
                TableRowCell(
                  text: '',
                  width: 70,
                  child: Center(
                    child: item.image.isNotEmpty
                        ? Image.network(
                            item.image, // Gunakan '${ApiService.baseUrl}/${item.image}' jika butuh base URL
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Tampilkan icon jika gambar gagal diload / link rusak
                              return const Icon(
                                Icons.broken_image,
                                size: 40,
                                color: Colors.grey,
                              );
                            },
                          )
                        : const Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                  ),
                ),

                // ===========================
                TableRowCell(
                  text: '',
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TableActionButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        onTap: () {
                          ctrl.deleteData(item.id);
                        },
                      ),
                      TableActionButton(
                        icon: Icons.edit,
                        color: Colors.blue,
                        onTap: () {
                          ctrl.openEditDialog(item);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 20),

          TablePagination(
            currentPage: ctrl.currentPage.value,
            totalPages: ctrl.totalPages.value,
            onNext: ctrl.nextPage,
            onPrevious: ctrl.previousPage,
          ),
        ],
      );
    });
  }
}
