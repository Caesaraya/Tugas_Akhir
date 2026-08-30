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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSidebar(),

          const VerticalDivider(width: 1),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =========================
                  // HEADER
                  // =========================
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

                  // =========================
                  // SUMMARY CARDS
                  // =========================
                  Obx(() {
                    final data = controller.keuangan.value;

                    // Profit minus?
                    final isProfitMinus = data.profit < 0;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          // =====================
                          // PEMASUKAN
                          // =====================
                          Expanded(
                            child: CardKeuangan(
                              judul: 'Pemasukan',
                              nominal: data.pemasukan,
                              subJudul: 'Total omset bulan ini',
                              icon: Icons.account_balance_wallet_outlined,
                              warnaAksen: Colors.blue,
                            ),
                          ),

                          // =====================
                          // PENGELUARAN
                          // =====================
                          Expanded(
                            child: CardKeuangan(
                              judul: 'Pengeluaran',
                              nominal: data.pengeluaran,
                              subJudul: 'Estimasi pengeluaran',
                              icon: Icons.shopping_cart_outlined,
                              warnaAksen: Colors.orange,
                            ),
                          ),

                          // =====================
                          // PROFIT
                          // =====================
                          Expanded(
                            child: CardKeuangan(
                              judul: 'Profit Bersih',
                              nominal: data.profit,
                              subJudul: isProfitMinus
                                  ? 'Kerugian bulan ini'
                                  : 'Keuntungan setelah dipotong',
                              icon: isProfitMinus
                                  ? Icons.trending_down
                                  : Icons.trending_up,
                              warnaAksen: isProfitMinus
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // =========================
                  // GRID AREA RESPONSIF
                  // =========================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // =====================
                        // MOBILE
                        // =====================
                        if (constraints.maxWidth < 900) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const TabelRekapKeuangan(),

                              const SizedBox(height: 20),

                              const TabelDetailPengeluaran(),

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

                        // =====================
                        // DESKTOP
                        // =====================
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Tabel rekap keuangan
                            const TabelRekapKeuangan(),

                            const SizedBox(height: 24),

                            // Detail pengeluaran
                            // vs komposisi
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 7,
                                  child: TabelDetailPengeluaran(),
                                ),

                                const SizedBox(width: 24),

                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const SizedBox(
                                        height: 360,
                                        child: KomposisiPengeluaran(),
                                      ),

                                      const SizedBox(height: 16),

                                      _buildActionAddButton(context),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),
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
