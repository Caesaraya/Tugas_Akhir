// lib/views/screens/bahan_baku/bahan_baku_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_controller.dart';
import 'package:tugas_akhir/widget/admin/bahan/bahan_baku_form_dialog.dart';
import 'package:tugas_akhir/widget/admin/bahan/tabel/bahan_baku_table.dart';
import 'package:tugas_akhir/widget/admin/bahan/tabel/bahan_top_bar.dart';
import 'package:tugas_akhir/widget/admin/custom_drawer.dart';

class BahanBakuScreen extends StatelessWidget {
  const BahanBakuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastikan controller teregistrasi (jika belum di-inject global)
    final controller = Get.find<BahanBakuController>();

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Rumah Lezzaaa'),
        backgroundColor: const Color(0xFF26C6DA),
      ),
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top bar ───────────────────────────────────────────────────────
          BahanBakuTopBar(onTambah: () => _openFormDialog(context)),

          // ── Table ─────────────────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: BahanBakuTable(
                onEdit: (index) {
                  final item = controller.filteredList[index];
                  _openFormDialog(context, item: item == null ? null : item);
                },
                onDelete: (id) => _confirmDelete(context, controller, id),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Open form dialog ──────────────────────────────────────────────────────
  void _openFormDialog(BuildContext context, {dynamic item}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => BahanBakuFormDialog(existing: item),
    );
  }

  // ── Confirm delete dialog ─────────────────────────────────────────────────
  void _confirmDelete(
    BuildContext context,
    BahanBakuController controller,
    int id,
  ) {
    final item = controller.bahanBakuList.firstWhereOrNull((b) => b.id == id);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Color(0xFFEF5350)),
            SizedBox(width: 8),
            Text('Hapus Bahan Baku'),
          ],
        ),
        content: Text(
          item != null
              ? 'Yakin ingin menghapus "${item.namaBahan}"?\nTindakan ini tidak dapat dibatalkan.'
              : 'Yakin ingin menghapus bahan baku ini?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await controller.delete(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
