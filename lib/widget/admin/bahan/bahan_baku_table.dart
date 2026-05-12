import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/widget/admin/table/table_action_button.dart';
import 'package:tugas_akhir/widget/admin/table/table_header_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_pagination.dart';
import 'package:tugas_akhir/widget/admin/table/table_row_cell.dart';

class BahanBakuTable extends StatelessWidget {
  BahanBakuTable({super.key});

  final ctrl = Get.put(BahanBakuTableController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: const [
              TableHeaderCell(title: 'ID', width: 60),
              TableHeaderCell(title: 'Nama Bahan', width: 200),
              TableHeaderCell(title: 'Merk', width: 150),
              TableHeaderCell(title: 'Satuan', width: 100),
              TableHeaderCell(title: 'Stok', width: 100),
              TableHeaderCell(title: 'Harga Satuan', width: 150),
              TableHeaderCell(title: 'Total Harga', width: 150),
              TableHeaderCell(title: 'Aksi', width: 150),
            ],
          ),

          ...ctrl.paginatedList.map((item) {
            return Row(
              children: [
                TableRowCell(text: item.id.toString(), width: 60),

                TableRowCell(text: item.namaBahan, width: 200),

                TableRowCell(text: item.merk, width: 150),

                TableRowCell(text: item.satuan, width: 100),

                TableRowCell(text: item.stok.toString(), width: 100),

                TableRowCell(text: item.hargaSatuan.toString(), width: 150),

                TableRowCell(text: item.totalHarga.toString(), width: 150),

                TableRowCell(
                  text: '',
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TableActionButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        onTap: () {
                          ctrl.deleteData(item.id!);
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
