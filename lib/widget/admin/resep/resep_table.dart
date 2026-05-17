import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/admin/table/table_header_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_pagination.dart';
import 'package:tugas_akhir/widget/admin/table/table_row_cell.dart';
import 'package:tugas_akhir/widget/admin/table/table_action_button.dart';
import '../../../controller/admin/resep_table_controller.dart';

class ResepTable extends StatelessWidget {
  ResepTable({super.key});

  final ctrl = Get.put(ResepTableController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        children: [
          // Header Tabel
          Row(
            children: const [
              TableHeaderCell(title: 'ID', width: 60),
              TableHeaderCell(title: 'Nama Resep', width: 200),
              TableHeaderCell(title: 'Deskripsi', width: 300),
              TableHeaderCell(title: 'Jumlah Bahan', width: 120),
              TableHeaderCell(title: 'Aksi', width: 120),
            ],
          ),

          // Data Body
          ...ctrl.paginatedList.map((item) {
            return Row(
              children: [
                TableRowCell(text: item.id.toString(), width: 60),
                TableRowCell(text: item.namaResep, width: 200),
                TableRowCell(
                  text: item.deskripsi,
                  width: 300,
                  // Tambahkan maxLines agar tidak berantakan jika deskripsi panjang
                ),
                // Di dalam resep_table.dart bagian baris data
                TableRowCell(
                  text: (item.bahan?.length ?? 0).toString(),
                  width: 120,
                ),
                TableRowCell(
                  text: '',
                  width: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Tombol Detail/Bahan
                      TableActionButton(
                        icon: Icons.list_alt,
                        color: Colors.green,
                        onTap: () {
                          ctrl.showDetailBahan(item);
                        },
                      ),
                      // Tombol Edit
                      TableActionButton(
                        icon: Icons.edit,
                        color: Colors.blue,
                        onTap: () => ctrl.openEditDialog(item),
                      ),
                      // Tombol Hapus
                      TableActionButton(
                        icon: Icons.delete,
                        color: Colors.red,
                        onTap: () {
                          if (item.id != null) ctrl.deleteData(item.id!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 20),

          // Pagination
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
