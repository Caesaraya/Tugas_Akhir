import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';

class BahanBakuListHeader extends StatelessWidget {
  final BahanBakuTableController controller;

  const BahanBakuListHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar Atas Penuh sesuai struktur Kelola Produk
          TableSearchBar(
            controller: controller.searchC,
            hint: 'Cari bahan baku...',
          ),
        ],
      ),
    );
  }
}
