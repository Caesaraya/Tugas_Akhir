import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/product.dart';
import '../../widget/widget desktop/dashboard/app_bar_desktop.dart';
import '../../widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import '../../widget/widget desktop/kelola/reusable_data_table.dart';
import '../../widget/widget desktop/kelola/pagination_widget.dart';
import '../../widget/widget desktop/kelola/product_edit_dialog.dart';
import '../../controller/mobile/product_controller.dart';
import '../../routes/routes.dart';

class KasirKelolaProduk extends StatelessWidget {
  const KasirKelolaProduk({super.key});

  String _shortenLink(String url, {int maxLength = 40}) {
    if (url.length <= maxLength) return url;
    return '${url.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.put(ProductController());

    return Scaffold(
      drawer: const DesktopNavigationDrawer(
        currentRoute: AppRoutes.kelolaProduk,
      ),
      backgroundColor: Colors.grey[200],

      body: Column(
        children: [
          AppBarDesktop(title: "Kelola Produk", showSearch: false),

          /// 🔍 SEARCH + BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: controller.updateSearchQuery,
                    decoration: InputDecoration(
                      hintText: "Cari Produk",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Obx(
                  () => ElevatedButton.icon(
                    onPressed: controller.filterOutOfStock,
                    icon: const Icon(Icons.menu),
                    label: const Text("Stok Habis"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: controller.isFilteringOutOfStock.value
                          ? Colors.orange
                          : Colors.amber,
                    ),
                  ),
                ),

                const SizedBox(width: 10),
              ],
            ),
          ),

          /// 📊 TABLE
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Obx(
                () => ReusableDataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Nama Produk")),
                    DataColumn(label: Text("Harga")),
                    DataColumn(label: Text("Stok")),
                    DataColumn(label: Text("Diskon")),
                    DataColumn(label: Text("Image")),
                    DataColumn(label: Text("Aksi")),
                  ],
                  rows: controller.paginatedProducts.map((Product p) {
                    return DataRow(
                      cells: [
                        DataCell(Text(p.id.toString())),
                        DataCell(Text(p.name)),
                        DataCell(Text('Rp${p.price}')),

                        // Stok
                        DataCell(
                          p.stock == 0
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Habis",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Text(p.stock.toString()),
                        ),

                        DataCell(Text('${p.discount}%')),
                        DataCell(
                          Tooltip(
                            message: p.image.isNotEmpty
                                ? p.image
                                : 'Tidak ada image',
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                p.image.isNotEmpty
                                    ? _shortenLink(p.image)
                                    : 'Tidak ada image',
                                style: TextStyle(
                                  color: p.image.isNotEmpty
                                      ? Colors.blue
                                      : Colors.grey,
                                  decoration: p.image.isNotEmpty
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ),

                        // Aksi
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ProductEditDialog(
                                      product: p,
                                      onSave: controller.saveProductChanges,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text("Edit"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  emptyMessage: 'Tidak ada produk yang ditemukan',
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            // child: Obx(
            //   () => PaginationWidget(
            //     currentPage: controller.currentPage.value,
            //     totalPages: controller.totalPages,
            //     pageSize: controller.pageSize,
            //     totalCount: controller.totalFilteredCount,
            //     onPreviousPage: controller.previousPage,
            //     onNextPage: controller.nextPage,
            //     itemName: 'produk',
            //     canGoPrevious: controller.currentPage.value > 1,
            //     canGoNext: controller.currentPage.value < controller.totalPages,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
