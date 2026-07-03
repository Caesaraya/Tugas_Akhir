import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controller/admin/product_table_controller.dart';
import '../../admin/table/table_action_button.dart';
import '../../admin/table/table_pagination.dart';

class ProductTable extends StatelessWidget {
  ProductTable({super.key});

  final ctrl = Get.find<ProductTableController>();
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    final headerColor = const Color(0xFF1E1E1E);

    return Obx(() {
      // Mengambil data halaman aktif dan ukuran item per halaman dari controller
      final currentList = ctrl.paginatedList;
      final int itemsPerPage = ctrl.itemsPerPage.bitLength;
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
                0: FixedColumnWidth(
                  50,
                ), // Lebar kolom No disesuaikan lebih ramping
                1: FlexColumnWidth(1.4), // Nama
                2: FlexColumnWidth(1.2), // Harga
                3: FixedColumnWidth(65), // Diskon
                4: FlexColumnWidth(1.3), // Harga Final
                5: FixedColumnWidth(60), // Stock
                6: FixedColumnWidth(90), // Status
                7: FlexColumnWidth(1.0), // Jenis
                8: FlexColumnWidth(1.0), // Satuan
                9: FixedColumnWidth(60), // Image
                10: FixedColumnWidth(100), // Aksi
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // ================== HEADER TABEL ==================
                TableRow(
                  decoration: BoxDecoration(color: headerColor),
                  children: [
                    _buildHeaderCell('No'), // DIUBAH: Dari 'ID' menjadi 'No'
                    _buildHeaderCell('Nama'),
                    _buildHeaderCell('Harga'),
                    _buildHeaderCell('Diskon'),
                    _buildHeaderCell('Harga Final'),
                    _buildHeaderCell('Stock'),
                    _buildHeaderCell('Status'),
                    _buildHeaderCell('Jenis'),
                    _buildHeaderCell('Satuan'),
                    _buildHeaderCell('Image'),
                    _buildHeaderCell('Aksi'),
                  ],
                ),

                // ================== BODY DATA ==================
                // DIUBAH: Menggunakan .asMap().entries untuk mendapatkan indeks baris saat ini
                ...currentList.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final item = entry.value;
                  final isStokTipis = item.stock <= 5;

                  // Kalkulasi Nomor Urut agar berlanjut di halaman berikutnya (Halaman 1: 1-10, Halaman 2: 11-20, dst)
                  final int rowNumber =
                      ((currentPage - 1) * itemsPerPage) + index + 1;

                  // Visual adjustment untuk item yang dihapus
                  final rowBgColor = item.isDeleted
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
                      // DIUBAH: Menampilkan nomor urut baris data, bukan ID unik database
                      _buildDataCell(rowNumber.toString()),
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

                      // Cell Status Badge
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
                              color: item.isDeleted
                                  ? Colors.red.shade100
                                  : Colors.green.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item.isDeleted ? 'DIHAPUS' : 'AKTIF',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: item.isDeleted
                                    ? Colors.red.shade700
                                    : Colors.green.shade700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      _buildDataCell(item.jenis),
                      _buildDataCell(item.satuan),

                      // Cell Gambar Produk
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

                      // Cell Tombol Aksi Dinamis
                      Container(
                        height: 48,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: item.isDeleted
                              ? [
                                  TableActionButton(
                                    icon: Icons.restore_rounded,
                                    color: Colors.green.shade700,
                                    onTap: () => ctrl.restoreProduct(item.id),
                                  ),
                                  const SizedBox(width: 8),
                                  TableActionButton(
                                    icon: Icons.delete_forever_rounded,
                                    color: Colors.red.shade900,
                                    onTap: () =>
                                        ctrl.forceDeleteProduct(item.id),
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
                                    onTap: () =>
                                        ctrl.softDeleteProduct(item.id),
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
                "Tidak ada produk ditemukan",
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
      height: 48,
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 8),
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