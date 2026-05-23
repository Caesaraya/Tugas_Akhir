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
    final headerColor = const Color(0xFF1E1E1E); // Disamakan menjadi Hitam

    return Obx(() {
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
                0: FixedColumnWidth(80), // ID sedikit diperlebar
                1: FlexColumnWidth(
                  1.5,
                ), // Menggunakan Flex agar responsif di layar desktop
                2: FlexColumnWidth(1.2),
                3: FixedColumnWidth(65),
                4: FlexColumnWidth(1.3),
                5: FixedColumnWidth(60),
                6: FlexColumnWidth(1.0),
                7: FlexColumnWidth(1.0),
                8: FlexColumnWidth(1.2),
                9: FixedColumnWidth(60),
                10: FixedColumnWidth(100), // Aksi disamakan 100
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // ================== HEADER TABEL ==================
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    _buildHeaderCell('ID'),
                    _buildHeaderCell('Nama'),
                    _buildHeaderCell('Harga'),
                    _buildHeaderCell('Diskon'),
                    _buildHeaderCell('Harga Final'),
                    _buildHeaderCell('Stock'),
                    _buildHeaderCell('Jenis'),
                    _buildHeaderCell('Satuan'),
                    _buildHeaderCell('Barcode'),
                    _buildHeaderCell('Image'),
                    _buildHeaderCell('Aksi'),
                  ],
                ),

                // ================== BODY DATA ==================
                ...ctrl.paginatedList.map((item) {
                  final isStokTipis =
                      item.stock <= 5; // Pola logic yang sama dengan bahan baku

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
                      _buildDataCell(item.id.toString()),
                      _buildDataCell(
                        item.name,
                        alignment: Alignment.centerLeft,
                      ),
                      _buildDataCell(
                        currencyFormatter.format(item.price),
                        alignment: Alignment.centerRight,
                      ),
                      _buildDataCell('${item.discount}%'),
                      _buildDataCell(
                        currencyFormatter.format(item.priceAfterDiscount),
                        alignment: Alignment.centerRight,
                        fontWeight: FontWeight.w600,
                      ),
                      _buildDataCell(
                        item.stock.toString(),
                        textColor: isStokTipis
                            ? Colors.red.shade700
                            : Colors.grey.shade800,
                        fontWeight: isStokTipis
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                      _buildDataCell(item.jenis),
                      _buildDataCell(item.satuan),
                      _buildDataCell(item.barcode),

                      // Cell Gambar Produk
                      TableCell(
                        child: Container(
                          height: 48, // Disamakan menjadi 48
                          alignment: Alignment.center,
                          child: item.image.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(
                                    item.image,
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.broken_image,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                  ),
                                )
                              : const Icon(
                                  Icons.image_not_supported,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                        ),
                      ),

                      // Cell Tombol Aksi
                      Container(
                        height: 48, // Disamakan menjadi 48
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TableActionButton(
                              icon: Icons.edit_outlined,
                              color: Colors.blue.shade700,
                              onTap: () => ctrl.openEditDialog(item),
                            ),
                            const SizedBox(width: 8),
                            TableActionButton(
                              icon: Icons.delete_outline_rounded,
                              color: Colors.red.shade600,
                              onTap: () => ctrl.deleteData(item.id),
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
                "Tidak ada produk",
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
      height: 46, // Disamakan dengan Bahan Baku
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
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
}
