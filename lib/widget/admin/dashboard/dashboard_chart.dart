import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Digunakan untuk memformat nominal Rupiah
import 'package:tugas_akhir/models/financial_report.dart';
import 'package:tugas_akhir/utils/app_color.dart';

class DashboardChart extends StatelessWidget {
  final List<FinancialReport> reports;

  const DashboardChart({Key? key, required this.reports}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listBulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    const secondaryTextColor = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);

    // Formatter Rupiah Indonesia tanpa desimal (.00)
    final rupiahFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    // Sesuai permintaan: batas nilai grafik tetap konsisten minimum 100rb dan maksimum 9jt
    const double minY = 100000;
    const double maxY = 9000000;

    // Interval grid pembagi sumbu Y agar pas dari nilai 100rb hingga 9jt
    const double yInterval = 2225000; // Pembagian grid berjarak seimbang

    return LayoutBuilder(
      builder: (context, constraints) {
        // DETEKSI LAYAR MOBILE: lebar di bawah 600dp dianggap mobile
        final bool isMobile = constraints.maxWidth < 600;

        // Tentukan lebar konten grafik secara responsive
        // Jika mobile, beri lebar minimal 650 agar batang chart memiliki ruang bernafas dan tidak berhimpitan
        final double chartWidth = isMobile ? 650.0 : constraints.maxWidth;

        // Base Chart Widget (Kedua device menggunakan tipe grafik yang sama)
        Widget buildBarChart() {
          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              minY:
                  0, // Mengalir dari dasar 0 agar proporsi batang akurat ke atas
              maxY: maxY,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String jenis = rodIndex == 0 ? 'Pemasukan' : 'Pengeluaran';
                    return BarTooltipItem(
                      '$jenis\n${rupiahFormat.format(rod.toY)}',
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                // ==================== SUMBU BAWAH (X) Nama Bulan ====================
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < 12) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 8,
                          child: Text(
                            listBulan[index],
                            style: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                // ==================== SUMBU KIRI (Y) Nominal Rupiah ====================
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    // Diperlebar menjadi 95 agar tulisan format panjang "Rp9.000.000" tidak terpotong/overflow
                    reservedSize: 95,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) {
                      // Custom penampilan teks untuk rentang nilai minimal dan kelipatannya
                      if (value == 0) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 6,
                          child: Text(
                            rupiahFormat.format(minY),
                            style: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 10,
                            ),
                          ),
                        );
                      } else if (value <= maxY) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          space: 6,
                          child: Text(
                            rupiahFormat.format(value),
                            style: const TextStyle(
                              color: secondaryTextColor,
                              fontSize: 10,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              // ==================== GRID LINE ====================
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: yInterval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: borderColor,
                  strokeWidth: 1,
                  dashArray: [4, 4],
                ),
              ),
              // ==================== DATA BATANG (Multiple Column) ====================
              barGroups: List.generate(12, (index) {
                final dataBulan = reports.firstWhere(
                  (r) => r.bulan == (index + 1),
                  orElse: () => FinancialReport(
                    tahun: DateTime.now().year,
                    bulan: index + 1,
                    pemasukan: 0,
                    pengeluaran: 0,
                    profit: 0,
                    totalTransaksi: 0,
                  ),
                );

                return BarChartGroupData(
                  x: index,
                  barsSpace: isMobile
                      ? 3
                      : 4, // Jarak antar batang Pemasukan & Pengeluaran
                  barRods: [
                    // Batang Pemasukan (Hitam)
                    BarChartRodData(
                      toY: dataBulan.pemasukan.clamp(0, maxY),
                      color: AppColors.black,
                      width: isMobile ? 12 : 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Batang Pengeluaran (Abu-abu)
                    BarChartRodData(
                      toY: dataBulan.pengeluaran.clamp(0, maxY),
                      color: const Color(0xFF9CA3AF),
                      width: isMobile ? 12 : 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
            ),
          );
        }

        // Layouting final yang responsive
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Jarak pemisah yang proporsional antara Judul Card atas dengan Area Grafik
              const SizedBox(height: 20),
              Expanded(
                child: isMobile
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: SizedBox(
                          width: chartWidth,
                          child: buildBarChart(),
                        ),
                      )
                    : SizedBox(width: chartWidth, child: buildBarChart()),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
