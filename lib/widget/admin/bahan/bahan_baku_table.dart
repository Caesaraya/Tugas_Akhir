import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/widget/admin/table/table_action_button.dart';
import 'package:tugas_akhir/widget/admin/table/table_header_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_row_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_pagination.dart';

class BahanBakuTable extends StatelessWidget {
  BahanBakuTable({super.key});

  final ctrl = Get.put(BahanBakuTableController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // Header Tabel
          Row(
            children: const [
              TableHeaderCell(title: "ID", width: 50),
              TableHeaderCell(title: "Nama Bahan", width: 150),
              TableHeaderCell(title: "Merk", width: 100),
              TableHeaderCell(title: "Satuan", width: 80),
              TableHeaderCell(title: "Stok", width: 60),
              TableHeaderCell(title: "Harga Satuan", width: 120),
              // Tambahan Kolom Total Harga
              TableHeaderCell(title: "Total Harga", width: 120),
              TableHeaderCell(title: "Aksi", width: 100),
            ],
          ),

          // Data Body
          ...ctrl.paginatedList.map((item) {
            return Row(
              children: [
                TableRowCell(text: item.id.toString(), width: 50),
                TableRowCell(text: item.namaBahan, width: 150),
                TableRowCell(text: item.merk, width: 100),
                TableRowCell(text: item.satuan, width: 80),
                TableRowCell(text: item.stok.toString(), width: 60),
                TableRowCell(
                  text: "Rp ${item.hargaSatuan.toStringAsFixed(0)}",
                  width: 120,
                ),

                // Menampilkan Total Harga (Mengambil dari model)
                TableRowCell(
                  text: "Rp ${item.totalHarga?.toStringAsFixed(0) ?? '0'}",
                  width: 120,
                  // Memberi warna berbeda agar menonjol
                ),

                TableRowCell(
                  text: "",
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TableActionButton(
                        icon: Icons.edit,
                        color: Colors.blue,
                        onTap: () => ctrl.openEditDialog(item),
                      ),
                      TableActionButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        onTap: () => ctrl.deleteData(item.id!),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Widget Pagination
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
