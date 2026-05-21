import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin/resep_table_controller.dart';
import '../../admin/table/table_action_button.dart';
import '../../admin/table/table_pagination.dart';

class ResepTable extends StatelessWidget {
  ResepTable({super.key});

  final ctrl = Get.put(ResepTableController());

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
                0: FixedColumnWidth(55), // ID
                1: FixedColumnWidth(160), // Nama Resep
                2: FixedColumnWidth(240), // Deskripsi
                3: FixedColumnWidth(110), // Jumlah Bahan
                4: FixedColumnWidth(120), // Aksi
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header
                TableRow(
                  decoration: BoxDecoration(color: primaryColor),
                  children: [
                    _buildHeaderCell('ID'),
                    _buildHeaderCell('Nama Resep'),
                    _buildHeaderCell('Deskripsi'),
                    _buildHeaderCell('Jumlah Bahan'),
                    _buildHeaderCell('Aksi'),
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
                      _buildDataCell(item.namaResep),
                      _buildDataCell(item.deskripsi),
                      _buildDataCell((item.bahan?.length ?? 0).toString()),

                      TableCell(
                        child: Container(
                          height: 44,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TableActionButton(
                                icon: Icons.list_alt,
                                color: Colors.green,
                                onTap: () => ctrl.showDetailBahan(item),
                              ),
                              TableActionButton(
                                icon: Icons.edit,
                                color: Colors.blue,
                                onTap: () => ctrl.openEditDialog(item),
                              ),
                              TableActionButton(
                                icon: Icons.delete,
                                color: Colors.red,
                                onTap: () {
                                  if (item.id != null)
                                    ctrl.deleteData(item.id!);
                                },
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
                "Tidak ada resep",
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
