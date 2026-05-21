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
    final primaryColor = Theme.of(context).primaryColor;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pembungkus utama tabel ber-radius manis dan bayangan halus
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
              // Mengatur proporsi lebar kolom secara absolut agar pas dengan layout dashboard
              columnWidths: const {
                0: FixedColumnWidth(40), // ID
                1: FixedColumnWidth(120), // Nama
                2: FixedColumnWidth(85), // Harga
                3: FixedColumnWidth(65), // Diskon
                4: FixedColumnWidth(90), // Harga Final
                5: FixedColumnWidth(50), // Stock
                6: FixedColumnWidth(65), // Jenis
                7: FixedColumnWidth(70), // Satuan
                8: FixedColumnWidth(65), // Barcode
                9: FixedColumnWidth(60), // Image
                10: FixedColumnWidth(85), // Aksi
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // ================== HEADER TABEL ==================
                TableRow(
                  decoration: BoxDecoration(color: primaryColor),
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
                      _buildDataCell(item.name),
                      _buildDataCell(currencyFormatter.format(item.price)),
                      _buildDataCell('${item.discount}%'),
                      _buildDataCell(
                        currencyFormatter.format(item.priceAfterDiscount),
                      ),
                      _buildDataCell(item.stock.toString()),
                      _buildDataCell(item.jenis),
                      _buildDataCell(item.satuan),
                      _buildDataCell(item.barcode),

                      // Cell Gambar Produk
                      TableCell(
                        child: Container(
                          height: 44,
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
                      TableCell(
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TableActionButton(
                                icon: Icons.delete,
                                color: Colors.red,
                                onTap: () => ctrl.deleteData(item.id),
                              ),
                              TableActionButton(
                                icon: Icons.edit,
                                color: Colors.blue,
                                onTap: () => ctrl.openEditDialog(item),
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
                "Tidak ada produk",
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
