import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';
import 'package:tugas_akhir/models/financial_report.dart';
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/admin/custom_sidebar.dart';
import 'package:tugas_akhir/widget/admin/dashboard/dashboard_activity_log.dart';
import 'package:tugas_akhir/widget/admin/dashboard/dashboard_chart.dart';
import 'package:tugas_akhir/widget/admin/dashboard/dashboard_header.dart';
import 'package:tugas_akhir/widget/admin/dashboard/dashboard_stok.dart';
import 'package:tugas_akhir/widget/admin/dashboard/dashboard_summary_card.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final KeuanganController controller = Get.find<KeuanganController>();
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    const backgroundColor = Color(0xFFF6F6F6);
    const borderColor = Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSidebar(),
          Expanded(
            child: Obx(() {
              // 1. Loading State
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.black),
                );
              }

              // 2. Ambil data bulan berjalan secara dinamis dari model FinancialReport
              final now = DateTime.now();
              final currentMonthReport = controller.filteredReports.firstWhere(
                (r) => r.bulan == now.month && r.tahun == now.year,
                orElse: () => FinancialReport(
                  tahun: now.year,
                  bulan: now.month,
                  pemasukan: 0,
                  pengeluaran: 0,
                  profit: 0,
                  totalTransaksi: 0,
                ),
              );

              return SingleChildScrollView(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardHeader(),
                    const SizedBox(height: 32),

                    // --- ROW SUMMARY CARDS ---
                    Row(
                      children: [
                        // Card Pemasukan Bulan Ini
                        Expanded(
                          child: DashboardSummaryCard(
                            title: 'Pemasukan Bulan Ini',
                            value: currencyFormat.format(
                              currentMonthReport.pemasukan,
                            ),
                            subtitle: 'Bulan berjalan',
                            isPositive: currentMonthReport.pemasukan >= 0,
                            sparklineColors: [
                              Colors.white,
                              Colors.white,
                            ], // Tidak ada grafik, jadi warna putih
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Card Profit Hari/Bulan Ini
                        Expanded(
                          child: DashboardSummaryCard(
                            title: 'Profit Bulan Ini',
                            value: currencyFormat.format(
                              currentMonthReport.profit,
                            ),
                            subtitle: 'Keuntungan bersih',
                            isPositive: currentMonthReport.profit >= 0,
                            sparklineColors: [Colors.white, Colors.white],
                          ),
                        ),
                        const SizedBox(width: 24),

                        // Card Total Transaksi Bulanan
                        Expanded(
                          child: DashboardSummaryCard(
                            title: 'Total Transaksi',
                            value:
                                '${currentMonthReport.totalTransaksi} Transaksi',
                            subtitle: 'Transaksi bulan ini',
                            isPositive: currentMonthReport.totalTransaksi >= 0,
                            sparklineColors: [Colors.white, Colors.white],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // --- SECTION GRAPH ---
                    Container(
                      height: 350,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Grafik Keuangan Bulanan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: DashboardChart(
                              reports: controller.filteredReports,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // --- SECTION STOK KRITIS & LOG ---
                    // SOLUSI: Mengganti IntrinsicHeight dengan Container bertinggi statis (height: 380)
                    Container(
                      height: 380,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Kolom Kiri: Tabel Stok Bahan Kritis
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: const DashboardStokKritis(),
                            ),
                          ),
                          const SizedBox(width: 24),

                          // Kolom Kanan: Aktivitas Terbaru (Timeline)
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: borderColor),
                              ),
                              child: const DashboardActivityLog(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
