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
                3: FlexColumnWidth(1.2), // Stok
                4: FlexColumnWidth(1.2), // Satuan
                5: FlexColumnWidth(1.8), // Harga Satuan
                6: FlexColumnWidth(2.0), // Total Nilai (KOLOM BARU)
                7: FixedColumnWidth(100), // Aksi
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // --- HEADER TABEL ---
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    _buildHeaderCell("ID"),
                    _buildHeaderCell("Nama Bahan"),
                    _buildHeaderCell("Merk"),
                    _buildHeaderCell("Stok"),
                    _buildHeaderCell("Satuan"),
                    _buildHeaderCell("Harga Satuan"),
                    _buildHeaderCell("Total Nilai"), // HEADER BARU
                    _buildHeaderCell("Aksi"),
                  ],
                ),

                // --- DATA BARIS TABEL ---
                ...ctrl.paginatedList.map((bahan) {
                  // Sesuai dengan spesifikasi kondisi di UI, stok menipis jika <= 5
                  final isStokTipis = (bahan.stok) <= 5;

                  // Hitung total harga item (Gunakan dari API jika tersedia, jika tidak hitung manual)
                  final totalHargaItem =
                      bahan.totalHarga ?? (bahan.stok * bahan.hargaSatuan);

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
                      _buildDataCell(bahan.id?.toString() ?? '-'),
                      _buildDataCell(
                        bahan.namaBahan,
                        alignment: Alignment.centerLeft,
                      ),
                      _buildDataCell(
                        bahan.merk,
                        alignment: Alignment.centerLeft,
                      ),
                      _buildDataCell(
                        bahan.stok.toString(),
                        textColor: isStokTipis
                            ? Colors.red.shade700
                            : Colors.grey.shade800,
                        fontWeight: isStokTipis
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                      _buildDataCell(bahan.satuan),
                      _buildDataCell(
                        currencyFormatter.format(bahan.hargaSatuan),
                        alignment: Alignment.centerRight,
                      ),

                      // --- DATA KOLOM TOTAL HARGA BARU ---
                      _buildDataCell(
                        currencyFormatter.format(totalHargaItem),
                        alignment: Alignment.centerRight,
                        fontWeight: FontWeight.w600,
                      ),

                      // --- KOLOM AKSI ---
                      Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TableActionButton(
                              icon: Icons.edit_outlined,
                              color: Colors.blue.shade700,
                              onTap: () => ctrl.openEditDialog(bahan),
                            ),
                            const SizedBox(width: 8),
                            TableActionButton(
                              icon: Icons.delete_outline_rounded,
                              color: Colors.red.shade600,
                              onTap: () => ctrl.deleteData(bahan.id!),
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
          fontSize: 13,
          fontWeight: fontWeight ?? FontWeight.w500,
        ),
      ),
    );
  }
}
