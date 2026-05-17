import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';

class BahanBakuDetailActionBar extends StatelessWidget {
  final BahanBakuTableController controller;
  final BahanBaku bahanBaku;

  const BahanBakuDetailActionBar({
    super.key,
    required this.controller,
    required this.bahanBaku,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.openEditDialog(bahanBaku),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Edit Bahan'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => controller.deleteData(bahanBaku.id!),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
