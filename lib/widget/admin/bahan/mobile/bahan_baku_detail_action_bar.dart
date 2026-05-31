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
    final isDeleted = bahanBaku.deletedAt != null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: isDeleted
            ? [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // 1. Ambil ID terlebih dahulu ke dalam variabel lokal agar aman
                      final idBahan = bahanBaku.id!;

                      // 2. Tutup halaman detail terlebih dahulu untuk menghindari crash re-render Obx
                      Get.back();

                      // 3. Jalankan fungsi restore di background setelah halaman ditutup
                      controller.restoreBahan(idBahan);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.green),
                      foregroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.restore_outlined),
                    label: const Text('Restore Bahan'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Berlaku hal yang sama untuk Force Delete demi keamanan navigasi
                      final idBahan = bahanBaku.id!;
                      Get.back();
                      controller.forceDeleteBahan(idBahan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade900,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    icon: const Icon(
                      Icons.delete_forever_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Hapus Permanen',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]
            : [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.showEditDialog(bahanBaku),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Bahan'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      controller.softDeleteBahan(bahanBaku.id!);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    label: const Text(
                      'Hapus',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
