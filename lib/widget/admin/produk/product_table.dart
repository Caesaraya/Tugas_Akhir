import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/admin/product_table_controller.dart';
import '../../admin/table/table_action_button.dart';
import '../../admin/table/table_pagination.dart';

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
                1: FlexColumnWidth(1.3), // Nama
                2: FlexColumnWidth(1.0), // Harga
                3: FixedColumnWidth(55), // Diskon
                4: FlexColumnWidth(1.1), // Harga Final
                5: FixedColumnWidth(55), // Stock
                6: FixedColumnWidth(95), // Status (Kolom Baru)
                7: FlexColumnWidth(0.9), // Jenis
                8: FlexColumnWidth(0.8), // Satuan
                9: FlexColumnWidth(1.1), // Barcode
                10: FixedColumnWidth(55), // Image
                11: FixedColumnWidth(125), // Aksi
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    _buildHeaderCell('ID'),
                    _buildHeaderCell('Nama'),
                    _buildHeaderCell('Harga'),
                    _buildHeaderCell('Diskon'),
                    _buildHeaderCell('Harga Final'),
                    _buildHeaderCell('Stock'),
                    _buildHeaderCell('Status'), // Header Baru
                    _buildHeaderCell('Jenis'),
                    _buildHeaderCell('Satuan'),
                    _buildHeaderCell('Barcode'),
                    _buildHeaderCell('Image'),
                    _buildHeaderCell('Aksi'),
                  ],
                ),
                ...ctrl.paginatedList.map((item) {
                  final isDeleted = item.deletedAt != null;
                  final isStokTipis = item.stock <= 5;

                  return TableRow(
                    decoration: BoxDecoration(
                      color: isDeleted
                          ? Colors.red.shade50.withOpacity(0.2)
                          : Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade100,
                          width: 1,
                        ),
                      ),
                    ),
                    children: [
                      _buildDataCell(item.id.toString()),
                      _buildDataCell(
                        item.name,
                        alignment: Alignment.centerLeft,
                        textColor: isDeleted ? Colors.grey : Colors.black,
                      ),
                      _buildDataCell(
                        currencyFormatter.format(item.price),
                        alignment: Alignment.centerRight,
                        textColor: isDeleted ? Colors.grey : Colors.black,
                      ),
                      _buildDataCell(
                        '${item.discount}%',
                        textColor: isDeleted ? Colors.grey : Colors.black,
                      ),
                      _buildDataCell(
                        currencyFormatter.format(item.priceAfterDiscount),
                        alignment: Alignment.centerRight,
                        fontWeight: FontWeight.bold,
                        textColor: isDeleted ? Colors.grey : Colors.black,
                      ),
                      _buildDataCell(
                        item.stock.toString(),
                        textColor: isDeleted
                            ? Colors.grey
                            : (isStokTipis ? Colors.red : Colors.black),
                      ),

                      // BADGE STATUS (AKTIF / DIHAPUS)
                      TableCell(
                        child: Center(
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
                              isDeleted ? 'DIHAPUS' : 'AKTIF',
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
                      ),

                      _buildDataCell(
                        item.jenis,
                        textColor: isDeleted ? Colors.grey : Colors.black,
                      ),
                      _buildDataCell(
                        item.satuan,
                        textColor: isDeleted ? Colors.grey : Colors.black,
                      ),
                      _buildDataCell(
                        item.barcode,
                        textColor: isDeleted ? Colors.grey : Colors.black,
                      ),
                      TableCell(
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: item.image.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    item.image,
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
                                    color: isDeleted ? Colors.grey : null,
                                    colorBlendMode: isDeleted
                                        ? BlendMode.saturation
                                        : null,
                                  ),
                                )
                              : const Icon(
                                  Icons.image_outlined,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                        ),
                      ),

                      // TOMBOL AKSI DINAMIS BERDASARKAN STATUS
                      TableCell(
                        child: Container(
                          height: 48,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: isDeleted
                                ? [
                                    TableActionButton(
                                      icon: Icons.restore_rounded,
                                      color: Colors.green,
                                      onTap: () => ctrl.confirmRestore(item.id),
                                    ),
                                    const SizedBox(width: 8),
                                    TableActionButton(
                                      icon: Icons.delete_forever_rounded,
                                      color: Colors.red.shade900,
                                      onTap: () =>
                                          ctrl.confirmForceDelete(item.id),
                                    ),
                                  ]
                                : [
                                    TableActionButton(
                                      icon: Icons.edit_square,
                                      color: Colors.blue,
                                      onTap: () => ctrl.openEditDialog(item),
                                    ),
                                    const SizedBox(width: 8),
                                    TableActionButton(
                                      icon: Icons.delete_outline_rounded,
                                      color: Colors.red,
                                      onTap: () =>
                                          ctrl.confirmSoftDelete(item.id),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ],
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
          fontSize: 13,
          color: textColor ?? Colors.grey.shade800,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
