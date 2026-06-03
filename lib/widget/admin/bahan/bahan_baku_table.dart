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
      final currentList = ctrl.paginatedList;
      // MENGGUNAKAN METHOD/PROPERTI YANG SUDAH ADA DI CONTROLLER (WARISAN BASE CONTROLLER)
      final int itemsPerPage = ctrl.itemsPerPage;
      final int currentPage = ctrl.currentPage.value;

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
                0: FixedColumnWidth(50), // Sesuai No (lebih ramping)
                1: FlexColumnWidth(2.5), // Nama Bahan
                2: FlexColumnWidth(1.5), // Merk
                3: FlexColumnWidth(1.5), // Stok Aktual
                4: FlexColumnWidth(1.5), // Satuan Unit
                5: FlexColumnWidth(1.8), // Harga Estimasi
                6: FixedColumnWidth(90), // Status Badge
                7: FixedColumnWidth(100), // Aksi
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // ================== HEADER TABEL ==================
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    _buildHeaderCell('No'), // DIUBAH: ID -> No
                    _buildHeaderCell('Nama Bahan'),
                    _buildHeaderCell('Merk'),
                    _buildHeaderCell('Stok'),
                    _buildHeaderCell('Satuan'),
                    _buildHeaderCell('Estimasi Harga'),
                    _buildHeaderCell('Status'),
                    _buildHeaderCell('Aksi'),
                  ],
                ),

                // ================== BODY DATA ==================
                ...currentList.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final item = entry.value;

                  // KALKULASI NOMOR URUT BERDASARKAN CURRENT PAGE & ITEMS PER PAGE CONTROLLER
                  final int rowNumber =
                      ((currentPage - 1) * itemsPerPage) + index + 1;

                  final isStokTipis = item.stok <= 5;
                  final rowBgColor = item.deletedAt != null
                      ? Colors.red.shade50
                      : Colors.white;

                  return TableRow(
                    decoration: BoxDecoration(
                      color: rowBgColor,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade100,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      // DIUBAH: Menggunakan rowNumber hasil kalkulasi
                      _buildDataCell(rowNumber.toString()),
                      _buildDataCell(
                        item.namaBahan,
                        alignment: Alignment.centerLeft,
                      ),
                      _buildDataCell(
                        item.merk.isEmpty ? '-' : item.merk,
                        alignment: Alignment.centerLeft,
                      ),
                      _buildDataCell(
                        item.stok.toString(),
                        textColor: isStokTipis
                            ? Colors.red.shade700
                            : Colors.grey.shade800,
                        fontWeight: isStokTipis
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                      _buildDataCell(item.satuan),
                      _buildDataCell(
                        currencyFormatter.format(item.hargaSatuan),
                        alignment: Alignment.centerRight,
                      ),
                      TableCell(
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: item.deletedAt != null
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.deletedAt != null ? 'DIHAPUS' : 'AKTIF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: item.deletedAt != null
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: item.deletedAt != null
                              ? [
                                  TableActionButton(
                                    icon: Icons.restore_rounded,
                                    color: Colors.green.shade700,
                                    onTap: () => ctrl.restoreBahan(item.id!),
                                  ),
                                  const SizedBox(width: 8),
                                  TableActionButton(
                                    icon: Icons.delete_forever_rounded,
                                    color: Colors.red.shade900,
                                    onTap: () =>
                                        ctrl.forceDeleteBahan(item.id!),
                                  ),
                                ]
                              : [
                                  TableActionButton(
                                    icon: Icons.edit_outlined,
                                    color: Colors.blue.shade700,
                                    onTap: () => ctrl.openEditDialog(item),
                                  ),
                                  const SizedBox(width: 8),
                                  TableActionButton(
                                    icon: Icons.delete_outline_rounded,
                                    color: Colors.red.shade600,
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
                "Tidak ada bahan baku ditemukan",
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
          fontSize: 13,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
