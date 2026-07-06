import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/models/dashboard_summary.dart';
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/admin/dashboard/dashboard_summary_card.dart';
import 'package:tugas_akhir/widget/admin/dashboard/dashboard_chart.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';

class DashboardMobileAdminPage extends StatelessWidget {
  const DashboardMobileAdminPage({super.key});

  static const _borderColor = Color(0xFFE5E7EB);
  static const _backgroundColor = Color(0xFFF6F6F6);
  static const _subTextColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    // Pemanggilan controller diperbarui menggunakan Get.find langsung
    final KeuanganController controller = Get.find<KeuanganController>();
    final BahanBakuTableController bahanCtrl =
        Get.find<BahanBakuTableController>();

    return Scaffold(
      drawer: const MobileAdminDrawer(),
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // Material 3 behavior fix
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildLoading();
          }

          if (controller.isDashboardError.value) {
            return _buildError(controller);
          }

          final summary = controller.dashboardSummary.value;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildSummarySection(summary),
                const SizedBox(height: 16),
                _buildChartSection(controller),
                const SizedBox(height: 16),
                _buildCriticalStockSection(bahanCtrl),
                const SizedBox(height: 16),
                _buildActivitySection(controller),
                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ======================================================================
  // PRIVATE WIDGET METHODS (UI COMPONENT SEPARATION)
  // ======================================================================

  Widget _buildHeader() {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(DateTime.now()),
              style: const TextStyle(color: _subTextColor, fontSize: 13),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: AppColors.black),
        ),
      ],
    );
  }

  Widget _buildSummarySection(DashboardSummary? summary) {
    final sparklineColors = [AppColors.black, AppColors.black.withOpacity(0.6)];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        DashboardSummaryCard(
          title: 'Omzet Hari Ini',
          value: summary?.formatCurrency(summary.omzetHariIni) ?? 'Rp 0',
          subtitle: summary != null ? summary.formatPersentase() : '-',
          isPositive: summary?.isNaik() ?? true,
          sparklineColors: sparklineColors,
        ),
        DashboardSummaryCard(
          title: 'Profit Bulan Ini',
          value: summary != null
              ? summary.formatCurrency(summary.profitBulanIni)
              : 'Rp 0',
          subtitle: 'Bulan berjalan',
          isPositive: summary != null ? summary.profitBulanIni >= 0 : true,
          sparklineColors: sparklineColors,
        ),
        DashboardSummaryCard(
          title: 'Total Transaksi',
          value: summary != null
              ? '${summary.totalTransaksiBulanIni} Transaksi'
              : '0 Transaksi',
          subtitle: 'Bulan ini',
          isPositive: true,
          sparklineColors: sparklineColors,
        ),
        DashboardSummaryCard(
          title: 'Bahan Kritis',
          value: summary != null ? '${summary.jumlahBahanKritis}' : '0',
          subtitle: 'Periksa stok',
          isPositive: (summary?.jumlahBahanKritis ?? 0) == 0,
          sparklineColors: sparklineColors,
        ),
      ],
    );
  }

  Widget _buildChartSection(KeuanganController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
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
          SizedBox(
            height: 220,
            child: DashboardChart(reports: controller.filteredReports),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalStockSection(BahanBakuTableController bahanCtrl) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
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
              _buildSectionButton(
                label: 'Lihat Semua',
                onPressed: () {
                  Get.toNamed('/kelolabahandesk');
                },
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
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Semua stok bahan baku aman 👍',
                  style: TextStyle(color: _subTextColor, fontSize: 13),
                ),
              );
            }

            final display = kritis.take(5).toList();
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: display.length,
              separatorBuilder: (_, __) => const Divider(
                color: _borderColor,
                height: 16,
                thickness: 0.8,
              ),
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
                            style: const TextStyle(
                              color: _subTextColor,
                              fontSize: 12,
                            ),
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

  Widget _buildActivitySection(KeuanganController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
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
              _buildSectionButton(label: 'Lihat Semua', onPressed: () {}),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final acts = controller.dashboardActivities;
            if (acts.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Belum ada aktivitas terbaru',
                  style: TextStyle(color: _subTextColor, fontSize: 13),
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
                      // Timeline node line indicator
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: _backgroundColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: _borderColor),
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
                                color: _borderColor,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Content box
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
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: _subTextColor,
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

  Widget _buildSectionButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.black,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.black),
    );
  }

  Widget _buildError(KeuanganController controller) {
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
              style: const TextStyle(color: _subTextColor, fontSize: 13),
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
