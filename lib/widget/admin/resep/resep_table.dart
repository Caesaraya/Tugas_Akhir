import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin/resep_table_controller.dart';
import '../../admin/table/table_action_button.dart';
import '../../admin/table/table_pagination.dart';

class ResepTable extends StatelessWidget {
  ResepTable({super.key});

  final ctrl = Get.find<ResepTableController>();

  @override
  Widget build(BuildContext context) {
    final headerColor = const Color(0xFF1E1E1E); // Disamakan menjadi Hitam

    return Obx(() {
      if (ctrl.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ), // Border tipis netral
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(60), // No (Sebelumnya ID)
                1: FlexColumnWidth(2.5), // Nama Resep
                2: FlexColumnWidth(3.5), // Deskripsi
                3: FlexColumnWidth(1.5), // Jumlah Bahan
                4: FixedColumnWidth(100), // Status
                5: FixedColumnWidth(140), // Ruang Aksi (bisa untuk 3 tombol)
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    _buildHeaderCell('No'), // UBAH: Dari 'ID' menjadi 'No'
                    _buildHeaderCell('Nama Resep'),
                    _buildHeaderCell('Deskripsi'),
                    _buildHeaderCell('Jumlah Bahan'),
                    _buildHeaderCell('Status'),
                    _buildHeaderCell('Aksi'),
                  ],
                ),
                // Body Data
                ...ctrl.paginatedList.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  bool isDeleted = item.deletedAt != null;

                  // HITUNG ANGKA URUT: (Halaman_Sekarang - 1) * Item_Per_Halaman + (Index + 1)
                  int nomorUrut =
                      ((ctrl.currentPage.value - 1) * ctrl.itemsPerPage) +
                      (index + 1);

                  return TableRow(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade100,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildDataCell(
                        nomorUrut.toString(),
                      ), // UBAH: Menggunakan nomorUrut hasil perhitungan
                      _buildDataCell(
                        item.namaResep,
                        alignment: Alignment.centerLeft,
                      ),
                      _buildDataCell(
                        item.deskripsi,
                        alignment: Alignment.centerLeft,
                      ),
                      // Sebelumnya: _buildDataCell((item.bahan?.length ?? 0).toString()),

                      // Diubah menjadi:
                      _buildDataCell(
                        item.bahan != null && item.bahan!.isNotEmpty
                            ? item.bahan!.length
                                  .toString() // Tampilkan angka jika data sudah dimuat
                            : '-', // Tampilkan strip atau teks netral jika data belum dimuat dari API utama
                        textColor: item.bahan != null && item.bahan!.isNotEmpty
                            ? Colors.grey.shade800
                            : Colors.grey.shade400,
                      ),

                      // Kolom Status
                      _buildStatusCell(isDeleted),

                      // Kolom Aksi
                      Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: isDeleted
                              ? [
                                  // State Terhapus: Detail, Restore & Force Delete
                                  TableActionButton(
                                    icon: Icons.list_alt_rounded,
                                    color: Colors.green.shade700,
                                    onTap: () => ctrl.goToDetailDesktop(item),
                                  ),
                                  const SizedBox(width: 6),
                                  TableActionButton(
                                    icon: Icons.restore,
                                    color: Colors.green.shade700,
                                    onTap: () => ctrl.restoreData(item.id!),
                                  ),
                                  const SizedBox(width: 6),
                                  TableActionButton(
                                    icon: Icons.delete_forever,
                                    color: Colors.red.shade600,
                                    onTap: () {
                                      if (item.id != null) {
                                        ctrl.forceDeleteData(item.id!);
                                      }
                                    },
                                  ),
                                ]
                              : [
                                  // State Aktif: Detail, Edit, Soft Delete
                                  TableActionButton(
                                    icon: Icons.list_alt_rounded,
                                    color: Colors.green.shade700,
                                    onTap: () => ctrl.goToDetailDesktop(item),
                                  ),
                                  const SizedBox(width: 6),
                                  TableActionButton(
                                    icon: Icons.edit_outlined,
                                    color: Colors.blue.shade700,
                                    onTap: () => ctrl.openEditDialog(item),
                                  ),
                                  const SizedBox(width: 6),
                                  TableActionButton(
                                    icon: Icons.delete_outline_rounded,
                                    color: Colors.red.shade600,
                                    onTap: () {
                                      if (item.id != null) {
                                        ctrl.deleteData(item.id!);
                                      }
                                    },
                                  ),
                                ],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          if (ctrl.paginatedList.isEmpty)
            Container(
              height: 150,
              alignment: Alignment.center,
              child: Text(
                "Tidak ada resep",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            ),

          const SizedBox(height: 16),
          Obx(
            () => TablePagination(
              currentPage: ctrl.currentPage.value,
              totalPages: ctrl.totalPages.value,
              onNext: () => ctrl.nextPage(),
              onPrevious: () => ctrl.previousPage(),
              onPageSelected: (targetPage) {
                ctrl.goToPage(targetPage);
              },
            ),
          ),
        ],
      );
    });
  }

  // ... (Sisa fungsi _buildHeaderCell, _buildDataCell, dan _buildStatusCell tetap sama di bawah)

  Widget _buildHeaderCell(String title) {
    return Container(
      height: 46, // Disamakan dengan Bahan Baku
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    Alignment alignment = Alignment.center,
    Color? textColor,
    FontWeight? fontWeight,
  }) {
    return Container(
      height: 48, // Disamakan dengan Bahan Baku
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor ?? Colors.grey.shade800,
          fontSize: 13,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusCell(bool isDeleted) {
    return Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isDeleted ? Colors.red.shade50 : Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDeleted ? Colors.red.shade200 : Colors.green.shade200,
          ),
        ),
        child: Text(
          isDeleted ? 'DIHAPUS' : 'AKTIF',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isDeleted ? Colors.red.shade700 : Colors.green.shade700,
          ),
        ),
      ),
    );
  }
}
