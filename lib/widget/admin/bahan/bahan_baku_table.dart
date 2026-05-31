import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/admin/bahan_baku_table_controller.dart';
import '../../admin/table/table_action_button.dart';
import '../../admin/table/table_pagination.dart';

class BahanBakuTable extends StatelessWidget {
  BahanBakuTable({super.key});

  final ctrl = Get.find<BahanBakuTableController>();

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final headerColor = const Color(0xFF1E1E1E);

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(60), // ID
                1: FlexColumnWidth(2.5), // Nama Bahan
                2: FlexColumnWidth(1.5), // Merk
                3: FlexColumnWidth(1.2), // Stok (Double format ready)
                4: FlexColumnWidth(1.5), // Harga Satuan
                5: FlexColumnWidth(1.5), // Total Harga
                6: FixedColumnWidth(110), // Status (KOLOM BARU)
                7: FixedColumnWidth(200), // Aksi
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header Table
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    _buildHeaderCell("ID"),
                    _buildHeaderCell("Nama Bahan"),
                    _buildHeaderCell("Merk"),
                    _buildHeaderCell("Stok"),
                    _buildHeaderCell("Harga Satuan"),
                    _buildHeaderCell("Total Harga"),
                    _buildHeaderCell("Status"), // HEADER BARU
                    _buildHeaderCell("Aksi"),
                  ],
                ),
                // Data Rows
                ...ctrl.paginatedList.map((item) {
                  final isDeleted = item.deletedAt != null;

                  return TableRow(
                    decoration: BoxDecoration(
                      color: isDeleted
                          ? Colors.red.shade50.withOpacity(0.4)
                          : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade100,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildDataCell("#${item.id}"),
                      _buildDataCell(
                        item.namaBahan,
                        alignment: Alignment.centerLeft,
                        fontWeight: FontWeight.w500,
                      ),
                      _buildDataCell(
                        item.merk,
                        alignment: Alignment.centerLeft,
                      ),
                      // Menampilkan stok format desimal jika berupa pecahan secara aman
                      _buildDataCell(
                        "${item.stok % 1 == 0 ? item.stok.toInt() : item.stok} ${item.satuan}",
                      ),
                      _buildDataCell(
                        currencyFormatter.format(item.hargaSatuan),
                        alignment: Alignment.centerRight,
                      ),
                      _buildDataCell(
                        currencyFormatter.format(
                          item.totalHarga ?? (item.stok * item.hargaSatuan),
                        ),
                        alignment: Alignment.centerRight,
                      ),

                      // BADGE STATUS (BAGIAN BARU)
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDeleted
                                ? Colors.red.shade100
                                : Colors.green.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isDeleted ? "DIHAPUS" : "AKTIF",
                            style: TextStyle(
                              color: isDeleted
                                  ? Colors.red.shade800
                                  : Colors.green.shade800,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // DINAMIS ACTION BUTTONS (BAGIAN BARU)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: isDeleted
                              ? [
                                  TableActionButton(
                                    icon: Icons.restore_outlined,
                                    color: Colors.green,
                                    onTap: () => ctrl.restoreBahan(item.id!),
                                  ),
                                  const SizedBox(width: 8),
                                  TableActionButton(
                                    icon: Icons.delete_forever_outlined,
                                    color: Colors.red.shade900,
                                    onTap: () =>
                                        ctrl.forceDeleteBahan(item.id!),
                                  ),
                                ]
                              : [
                                  TableActionButton(
                                    icon: Icons.edit_outlined,
                                    color: Colors.blue,
                                    onTap: () => ctrl.showEditDialog(item),
                                  ),
                                  const SizedBox(width: 8),
                                  TableActionButton(
                                    icon: Icons.delete_outline,
                                    color: Colors.red,
                                    onTap: () => ctrl.softDeleteBahan(item.id!),
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
                "Tidak ada data bahan baku",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
            ),
          const SizedBox(height: 16),
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

  Widget _buildHeaderCell(String title) {
    return Container(
      height: 46,
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
      height: 48,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor ?? Colors.grey.shade800,
          fontWeight: fontWeight ?? FontWeight.normal,
          fontSize: 13,
        ),
      ),
    );
  }
}
