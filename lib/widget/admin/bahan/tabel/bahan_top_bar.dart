// lib/views/widgets/bahan_baku/bahan_baku_top_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_controller.dart';
import 'package:tugas_akhir/widget/admin/action_button.dart';
import 'package:tugas_akhir/widget/admin/refresh_button.dart';

class BahanBakuTopBar extends StatelessWidget {
  const BahanBakuTopBar({super.key, required this.onTambah});

  final VoidCallback onTambah;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BahanBakuController>();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // ── Judul ───────────────────────────────────────
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kelola Bahan Baku',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                'Manajemen stok & harga bahan baku',
                style: TextStyle(fontSize: 12, color: Color(0xFF888888)),
              ),
            ],
          ),
          const Spacer(),

          // ── Search ──────────────────────────────────────
          SizedBox(
            width: 220,
            height: 38,
            child: TextField(
              onChanged: controller.onSearch,
              decoration: InputDecoration(
                hintText: 'Cari bahan baku...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFFAAAAAA),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 18,
                  color: Color(0xFFAAAAAA),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                filled: true,
                fillColor: const Color(0xFFF0F2F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(width: 10),

          // ── Refresh (reuse existing widget) ─────────────
          ProductRefreshButton(onPressed: controller.fetchAll),
          const SizedBox(width: 10),

          // ── Tambah (reuse existing widget) ──────────────
          ProductActionButton(
            label: 'Tambah Bahan Baku',
            icon: Icons.add,
            color: const Color(0xFF2196F3),
            onPressed: onTambah,
          ),
        ],
      ),
    );
  }
}
