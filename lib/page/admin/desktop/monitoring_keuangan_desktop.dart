import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/dialogs/uang/dialog_tambah_pengeluaran.dart';
import 'package:tugas_akhir/widget/admin/uang/card_keuangan.dart';
import 'package:tugas_akhir/widget/admin/uang/tabel_keuangan.dart';
import 'package:tugas_akhir/widget/admin/uang/komposisi_pengeluaran.dart';
import '../../../controller/admin/keuangan_controller.dart';

class MonitoringKeuanganPage extends StatelessWidget {
  MonitoringKeuanganPage({super.key});

  final controller = Get.put(KeuanganController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          AdminSidebar(),
          const VerticalDivider(width: 1),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Halaman Utama
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
                  padding: EdgeInsets.only(left: 24, bottom: 24),
                  child: Text(
                    "Ringkasan pemasukan dan performa bisnis bulan ini",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),

                // SUMMARY CARD (TETAP DI-RENDER UTUH & BERJALAN NORMAL)
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

                // GRID RESPONSIF (70:30 ATAU 65:35 ATAU VERTICAL TUMPANG)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // 1. LAYOUT MOBILE (< 900px)
                        if (constraints.maxWidth < 900) {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const SizedBox(
                                  height: 380,
                                  child: TabelRekapKeuangan(),
                                ),
                                const SizedBox(height: 20),
                                const SizedBox(
                                  height: 360,
                                  child: KomposisiPengeluaran(),
                                ),
                                const SizedBox(height: 16),
                                _buildActionAddButton(context),
                                const SizedBox(height: 24),
                              ],
                            ),
                          );
                        }

                        // 2. LAYOUT TABLET / DESKTOP PROPORSI (70:30 atau 65:35)
                        double leftFlex = constraints.maxWidth < 1150
                            ? 6.5
                            : 7.0;
                        double rightFlex = constraints.maxWidth < 1150
                            ? 3.5
                            : 3.0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // KIRI: Tabel Rekap Keuangan
                              Expanded(
                                flex: (leftFlex * 10).toInt(),
                                child: const TabelRekapKeuangan(),
                              ),
                              const SizedBox(width: 24),
                              // KANAN: Komposisi Donut Chart + Tombol Tambah
                              Expanded(
                                flex: (rightFlex * 10).toInt(),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Expanded(
                                      child: KomposisiPengeluaran(),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildActionAddButton(context),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
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
          backgroundColor: const Color(
            0xFF1E1E1E,
          ), // Konsisten menggunakan Hitam Dashboard Project
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
