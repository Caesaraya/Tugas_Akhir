import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/admin/table/table_header_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_pagination.dart';
import 'package:tugas_akhir/widget/admin/table/table_row_cell.dart';

import '../../../controller/admin/product_table_controller.dart';
import '../../admin/table/table_action_button.dart';

class ProductTable extends StatelessWidget {
  ProductTable({super.key});

  final ctrl = Get.put(ProductTableController());

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
              TableHeaderCell(title: 'Image', width: 70),
              TableHeaderCell(title: 'Aksi', width: 100),
            ],
          ),

          ...ctrl.paginatedList.map((item) {
            return Row(
              children: [
                TableRowCell(text: item.id.toString(), width: 60),

                TableRowCell(text: item.name, width: 150),

                TableRowCell(text: 'Rp ${item.price}', width: 100),

                TableRowCell(text: '${item.discount}%', width: 60),

                TableRowCell(text: 'Rp ${item.priceAfterDiscount}', width: 100),

                TableRowCell(text: item.stock.toString(), width: 60),

                TableRowCell(text: item.jenis, width: 90),

                TableRowCell(text: item.satuan, width: 60),

                TableRowCell(text: item.barcode, width: 90),

                TableRowCell(text: item.image, width: 70),

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
                        onTap: () {},
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
