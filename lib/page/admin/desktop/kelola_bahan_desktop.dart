// lib/views/screens/bahan_baku/bahan_baku_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/widget/admin/bahan/bahan_baku_table.dart';
import 'package:tugas_akhir/widget/admin/bahan/summary_card.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/dialogs/bahan/insert_bahan_baku_dialog.dart';
import 'package:tugas_akhir/widget/admin/table/table_search_bar.dart';
import 'package:tugas_akhir/widget/admin/table/table_toolbar.dart';

class BahanBakuScreen extends StatelessWidget {
  BahanBakuScreen({super.key}) {
    Get.find<NavigationController>().selectedIndex.value = 1;
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BahanBakuTableController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSidebar(),
          Expanded(
            child: SingleChildScrollView(
              // ← Membungkus seluruh konten kanan agar bisa di-scroll
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kelola Bahan Baku',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E1E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manajemen stok dan harga bahan baku produksi kue',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Obx(() {
                      return Row(
                        children: [
                          SummaryCard(
                            title: 'Nilai Inventory',
                            value: ctrl.formatRingkasanMataUang(
                              ctrl.totalNilaiInventory,
                            ),
                            subtitle: 'total nilai inventory',
                            subtitleColor: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 16),
                          SummaryCard(
                            title: 'Total Bahan',
                            value: ctrl.totalBahanAktif.toString(),
                            subtitle: 'Aktif di sistem',
                            subtitleColor: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 16),
                          SummaryCard(
                            title: 'Stok Menipis',
                            value: ctrl.jumlahStokMenipis.toString(),
                            subtitle: 'Perlu restok segera',
                            subtitleColor: Colors.orange.shade700,
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text(
                          "Daftar Bahan Baku",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        TableSearchBar(controller: ctrl.searchC),
                        const SizedBox(width: 12),
                        ToolbarButton(
                          title: 'Tambah Bahan',
                          icon: Icons.add_rounded,
                          color: const Color(0xFF1E1E1E),
                          onTap: () {
                            ctrl.clearForm();
                            Get.dialog(InsertBahanBakuDialog());
                          },
                        ),
                        const SizedBox(width: 12),
                        ToolbarButton(
                          title: "Stock habis",
                          icon: Icons.warning_amber_rounded,
                          color: Colors.black54,
                          onTap: () {
                            ctrl.toggleFilterStockHabis();
                          },
                        ),
                        const SizedBox(width: 12),
                        ToolbarButton(
                          title: "",
                          icon: Icons.refresh_outlined,
                          color: Colors.grey.shade400,
                          onTap: () {
                            ctrl.fetchData();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // ← Menghapus Expanded dan SingleChildScrollView bawaan tabel agar menyatu dengan scroll utama
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: BahanBakuTable(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
