import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/admin/bahan_baku_table_controller.dart';
import '../../admin/table/table_action_button.dart';
import '../../admin/table/table_pagination.dart';

class BahanBakuTable extends StatelessWidget {
  BahanBakuTable({super.key});

  final ctrl = Get.put(BahanBakuTableController());
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(50), // ID
                1: FixedColumnWidth(150), // Nama Bahan
                2: FixedColumnWidth(100), // Merk
                3: FixedColumnWidth(80), // Satuan
                4: FixedColumnWidth(70), // Stok
                5: FixedColumnWidth(110), // Harga Satuan
                6: FixedColumnWidth(120), // Total Harga
                7: FixedColumnWidth(90), // Aksi
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(color: primaryColor),
                  children: [
                    _buildHeaderCell("ID"),
                    _buildHeaderCell("Nama Bahan"),
                    _buildHeaderCell("Merk"),
                    _buildHeaderCell("Satuan"),
                    _buildHeaderCell("Stok"),
                    _buildHeaderCell("Harga Satuan"),
                    _buildHeaderCell("Total Harga"),
                    _buildHeaderCell("Aksi"),
                  ],
                ),
                // Body Data
                ...ctrl.paginatedList.asMap().entries.map((entry) {
                  int index = entry.key;
                  var item = entry.value;
                  Color rowBgColor = index % 2 == 0
                      ? Colors.white
                      : Colors.grey.shade50;

                  return TableRow(
                    decoration: BoxDecoration(
                      color: rowBgColor,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade100),
                      ),
                    ),
                    children: [
                      _buildDataCell(item.id.toString()),
                      _buildDataCell(item.namaBahan),
                      _buildDataCell(item.merk),
                      _buildDataCell(item.satuan),
                      _buildDataCell(item.stok.toString()),
                      _buildDataCell(
                        currencyFormatter.format(item.hargaSatuan),
                      ),
                      _buildDataCell(
                        currencyFormatter.format(item.totalHarga ?? 0),
                      ),

                      TableCell(
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
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
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          if (ctrl.paginatedList.isEmpty)
            Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(
                "Tidak ada data",
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ),

          const SizedBox(height: 12),
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
      height: 40,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.grey.shade800,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
