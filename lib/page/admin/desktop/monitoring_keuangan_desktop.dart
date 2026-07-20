// lib/page/admin/uang/monitoring_keuangan_desktop.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/navigation_controller.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/dialogs/uang/dialog_tambah_pengeluaran.dart';
import 'package:tugas_akhir/widget/admin/uang/card_keuangan.dart';
import 'package:tugas_akhir/widget/admin/uang/tabel_keuangan.dart';
import 'package:tugas_akhir/widget/admin/uang/tabel_pengeluaran.dart';
import 'package:tugas_akhir/widget/admin/uang/komposisi_pengeluaran.dart';
import '../../../controller/admin/keuangan_controller.dart';

class MonitoringKeuanganPage extends StatelessWidget {
  MonitoringKeuanganPage({super.key});

  final controller = Get.find<KeuanganController>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NavigationController>().selectedIndex.value = 4;
    });
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Sejajar di bagian atas dengan Sidebar
        children: [
          AdminSidebar(),
          const VerticalDivider(width: 1),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- HEADER HALAMAN UTAMA ---
                  const Padding(
                    padding: EdgeInsets.only(left: 24, top: 24),
                    child: Text(
                      "Monitoring Keuangan",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 20),
                    child: Text(
                      "Ringkasan pemasukan dan performa bisnis bulan ini",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),

                  // --- SUMMARY CARDS ---
                  Obx(() {
                    final data = controller.keuangan.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: CardKeuangan(
                              judul: 'Pemasukan',
                              nominal: data.pemasukan,
                              subJudul: 'Total omset bulan ini',
                              icon: Icons.account_balance_wallet_outlined,
                              warnaAksen: Colors.blue,
                            ),
                          ),
                          Expanded(
                            child: CardKeuangan(
                              judul: 'Pengeluaran',
                              nominal: data.pengeluaran,
                              subJudul: 'Estimasi pengeluaran',
                              icon: Icons.shopping_cart_outlined,
                              warnaAksen: Colors.orange,
                            ),
                          ),
                          Expanded(
                            child: CardKeuangan(
                              judul: 'Profit Bersih',
                              nominal: data.profit,
                              subJudul: 'Keuntungan setelah dipotong',
                              icon: Icons.trending_up,
                              warnaAksen: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // --- GRID AREA RESPONSIF & FLEXIBLE ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // ================= LAYOUT MOBILE (< 900px) =================
                        if (constraints.maxWidth < 900) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const TabelRekapKeuangan(), // Auto-height penuh
                              const SizedBox(height: 20),
                              const TabelDetailPengeluaran(), // Auto-height rekap kategori
                              const SizedBox(height: 20),
                              const SizedBox(
                                height: 360,
                                child: KomposisiPengeluaran(),
                              ),
                              const SizedBox(height: 16),
                              _buildActionAddButton(context),
                              const SizedBox(height: 24),
                            ],
                          );
                        }

                        // ================= LAYOUT DESKTOP PROFESIONAL =================
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // BARIS ATAS: Tabel Rekap Keuangan Bulanan (Full Width & Auto-Height)
                            const TabelRekapKeuangan(),

                            const SizedBox(height: 24),

                            // BARIS BAWAH: Detail Pengeluaran (70%) vs Komposisi Chart (30%)
                            // Menggunakan CrossAxisAlignment.start agar tinggi mengikuti anak paling tinggi secara alami
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // KIRI: Tabel Rekap Kategori (70% Lebar & Auto-Height Tanpa Terpotong)
                                const Expanded(
                                  flex: 7,
                                  child: TabelDetailPengeluaran(),
                                ),
                                const SizedBox(width: 24),

                                // KANAN: Komposisi Chart & Tombol Tambah (30% Lebar)
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                        height:
                                            360, // Mengunci tinggi Donut Chart agar proporsional di dalam Card-nya
                                        child: KomposisiPengeluaran(),
                                      ),
                                      const SizedBox(height: 16),
                                      // Tombol Tambah Pengeluaran yang menempel di bawah chart
                                      _buildActionAddButton(context),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 40,
                            ), // Spacing akhir dasar halaman
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionAddButton(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1E1E1E),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const DialogTambahPengeluaran(),
          );
        },
        icon: const Icon(Icons.add_rounded, size: 18),
        label: const Text(
          "Tambah Pengeluaran",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),
    );
  }
}
