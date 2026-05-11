// lib/views/widgets/bahan_baku/bahan_baku_table.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_controller.dart';

import 'package:tugas_akhir/widget/admin/bahan/tabel/bahan_table_row.dart';
import 'package:tugas_akhir/widget/admin/produk/tabel/produk_table_header.dart';

class BahanBakuTable extends StatelessWidget {
  const BahanBakuTable({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final void Function(int index) onEdit;
  final void Function(int id) onDelete;

  static const List<String> _columns = [
    'No',
    'Nama Bahan',
    'Merk',
    'Satuan',
    'Stok',
    'Harga Satuan',
    'Total Harga',
    'Aksi',
  ];

  static const List<double?> _colWidths = [
    50,
    160,
    120,
    80,
    80,
    130,
    130,
    null,
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BahanBakuController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header (reuse existing widget) ──────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: TableHeader(columns: _columns, colWidths: _colWidths),
          ),

          // ── Body ────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF2196F3)),
                );
              }

              final list = controller.filteredList;

              if (list.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 48,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 8),
                      Obx(
                        () => Text(
                          controller.searchQuery.value.isEmpty
                              ? 'Belum ada data bahan baku'
                              : 'Data tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (_, i) => BahanBakuTableRow(
                  index: i + 1,
                  item: list[i],
                  isEven: i % 2 == 0,
                  colWidths: _colWidths,
                  onEdit: () => onEdit(i),
                  onDelete: () => onDelete(list[i].id!),
                ),
              );
            }),
          ),

          // ── Footer ──────────────────────────────────────
          _buildFooter(controller),
        ],
      ),
    );
  }

  Widget _buildFooter(BahanBakuController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF0F2F5))),
      ),
      child: Obx(
        () => Row(
          children: [
            Text(
              'Total: ${controller.filteredList.length} data',
              style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
            ),
            if (controller.searchQuery.value.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                '(dari ${controller.bahanBakuList.length} bahan baku)',
                style: const TextStyle(fontSize: 12, color: Color(0xFFAAAAAA)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
