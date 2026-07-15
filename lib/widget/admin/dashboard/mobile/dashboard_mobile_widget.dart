import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/models/dashboard_summary.dart';
import 'package:tugas_akhir/models/financial_report.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/admin/dashboard/dashboard_summary_card.dart';
import 'package:tugas_akhir/widget/admin/dashboard/mobile/dashboard_chart_mobile.dart';

/// Widget List Summary Card (Menyalin data/logic dari Desktop & disusun Vertikal)
class DashboardSummaryList extends StatelessWidget {
  final KeuanganController controller;

  const DashboardSummaryList({
    super.key,
    required this.controller,
    DashboardSummary? summary,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    // Mengambil data bulan berjalan secara dinamis sesuai logic dashboard desktop
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

    return Column(
      children: [
        // Card 1: Pemasukan Bulan Ini
        DashboardSummaryCard(
          title: 'Pemasukan Bulan Ini',
          value: currencyFormat.format(currentMonthReport.pemasukan),
          subtitle: 'Bulan berjalan',
          isPositive: currentMonthReport.pemasukan >= 0,
          sparklineColors: const [Colors.white, Colors.white],
        ),
        const SizedBox(height: 12),

        // Card 2: Profit Bulan Ini
        DashboardSummaryCard(
          title: 'Profit Bulan Ini',
          value: currencyFormat.format(currentMonthReport.profit),
          subtitle: 'Keuntungan bersih',
          isPositive: currentMonthReport.profit >= 0,
          sparklineColors: const [Colors.white, Colors.white],
        ),
        const SizedBox(height: 12),

        // Card 3: Total Transaksi Bulanan
        DashboardSummaryCard(
          title: 'Total Transaksi',
          value: '${currentMonthReport.totalTransaksi} Transaksi',
          subtitle: 'Transaksi bulan ini',
          isPositive: currentMonthReport.totalTransaksi >= 0,
          sparklineColors: const [Colors.white, Colors.white],
        ),
      ],
    );
  }
}

/// Widget Section Grafik Pemasukan vs Pengeluaran
class DashboardChartSection extends StatelessWidget {
  final KeuanganController controller;
  final Color borderColor;

  const DashboardChartSection({
    super.key,
    required this.controller,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Pemasukan vs Pengeluaran',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 16),
          DashboardChartMobile(reports: controller.filteredReports),
        ],
      ),
    );
  }
}

/// Widget Section Tabel Stok Bahan Kritis
class DashboardCriticalStockSection extends StatelessWidget {
  final BahanBakuTableController bahanCtrl;
  final Color borderColor;
  final Color subTextColor;

  const DashboardCriticalStockSection({
    super.key,
    required this.bahanCtrl,
    required this.borderColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Stok Bahan Kritis',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.kelolaBahanMob);
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            final kritis = bahanCtrl.originalList
                .where(
                  (b) => b.deletedAt == null && (b.stok == 0 || b.stok < 10),
                )
                .toList();

            if (bahanCtrl.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.black),
                ),
              );
            }

            if (kritis.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Semua stok bahan baku aman 👍',
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
              );
            }

            final display = kritis.take(5).toList();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: display.length,
              separatorBuilder: (_, __) =>
                  Divider(color: borderColor, height: 16, thickness: 0.8),
              itemBuilder: (context, index) {
                final b = display[index];
                final isHabis = b.stok == 0;
                final statusColor = isHabis
                    ? Colors.red
                    : Colors.amber.shade800;

                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.namaBahan,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${b.stok} ${b.satuan} • ${b.merk.isEmpty ? '-' : b.merk}',
                            style: TextStyle(color: subTextColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isHabis ? 'Habis' : 'Menipis',
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

/// Widget Section Aktivitas Terbaru
class DashboardActivitySection extends StatelessWidget {
  final KeuanganController controller;
  final Color borderColor;
  final Color subTextColor;
  final Color backgroundColor;

  const DashboardActivitySection({
    super.key,
    required this.controller,
    required this.borderColor,
    required this.subTextColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Aktivitas Terbaru',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final acts = controller.dashboardActivities;
            if (acts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Belum ada aktivitas terbaru',
                  style: TextStyle(color: subTextColor, fontSize: 13),
                ),
              );
            }

            final display = acts.take(5).toList();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: display.length,
              itemBuilder: (context, index) {
                final a = display[index];
                final isLast = index == display.length - 1;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor),
                            ),
                            child: Text(
                              a.icon,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 1.5,
                                color: borderColor,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: isLast ? 0.0 : 16.0,
                            top: 2.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  a.deskripsi,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.black,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                a.formatWaktu(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: subTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

/// Widget State Loading
class DashboardLoadingWidget extends StatelessWidget {
  const DashboardLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.black),
    );
  }
}

/// Widget State Error
class DashboardErrorWidget extends StatelessWidget {
  final KeuanganController controller;
  final Color subTextColor;

  const DashboardErrorWidget({
    super.key,
    required this.controller,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Gagal memuat Dashboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              controller.dashboardErrorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(color: subTextColor, fontSize: 13),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: controller.loadDashboardData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
