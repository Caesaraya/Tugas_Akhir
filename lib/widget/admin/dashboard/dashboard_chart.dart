import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
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

    // Konfigurasi Batas Minimal Sesuai Instruksi
    double minY = 100000;

    // 1. Ambil nilai tertinggi mutlak dari pemasukan maupun pengeluaran
    double rawMax = 0;
    for (final r in reports) {
      if (r.pemasukan > rawMax) rawMax = r.pemasukan;
      if (r.pengeluaran > rawMax) rawMax = r.pengeluaran;
    }

    double maxY;
    double yInterval;

    // 2. Kalkulasi Dynamic MaxY dan Interval Proporsional
    if (rawMax <= 0) {
      // Fallback jika data kosong / 0
      maxY = 1000000;
      yInterval = 200000;
    } else {
      // Tentukan ordo besaran (misal: jika rawMax 12 juta -> magnitude = 10 juta)
      double magnitude = math
          .pow(10, (math.log(rawMax) / math.ln10).floor())
          .toDouble();

      // Hitung rasio murni (selalu menghasilkan angka 1.0 s/d 9.99...)
      double val = rawMax / magnitude;

      double maxMultiplier;
      double intervalMultiplier;

      // Pemetaan ke skala "Rapi" terdekat yang memberi sedikit ruang kosong di atas grafik
      if (val <= 1.1) {
        maxMultiplier = 1.2;
        intervalMultiplier = 0.3;
      } else if (val <= 1.49) {
        maxMultiplier = 1.5;
        intervalMultiplier = 0.5;
      } else if (val <= 1.9) {
        maxMultiplier = 2.0;
        intervalMultiplier = 0.5;
      } else if (val <= 2.4) {
        maxMultiplier = 2.5;
        intervalMultiplier = 0.5;
      } else if (val <= 2.9) {
        maxMultiplier = 3.0;
        intervalMultiplier = 1.0;
      } else if (val <= 3.9) {
        maxMultiplier = 4.0;
        intervalMultiplier = 1.0;
      } else if (val <= 4.9) {
        maxMultiplier = 5.0;
        intervalMultiplier = 1.0;
      } else if (val <= 5.9) {
        maxMultiplier = 6.0;
        intervalMultiplier = 2.0;
      } else if (val <= 7.9) {
        maxMultiplier = 8.0;
        intervalMultiplier = 2.0;
      } else {
        maxMultiplier = 10.0;
        intervalMultiplier = 2.0;
      }

      maxY = maxMultiplier * magnitude;
      yInterval = intervalMultiplier * magnitude;
    }

    // Pengaman terakhir agar maxY tidak pernah <= minY.
    if (maxY <= minY) {
      maxY = minY + yInterval;
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        minY: minY,
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String type = rodIndex == 0 ? "Pemasukan" : "Pengeluaran";
              final formatCurrency = NumberFormat.currency(
                locale: 'id',
                symbol: 'Rp ',
                decimalDigits: 0,
              );
              return BarTooltipItem(
                '$type\n${formatCurrency.format(rod.toY)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
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
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 55,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value < minY || value > maxY) {
                  return const SizedBox.shrink();
                }

                final String labelText = _formatYLabel(value);

                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  space: 8,
                  child: Text(
                    labelText,
                    style: const TextStyle(
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                    ),
                  ),
                );
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
        gridData: FlGridData(
          show: true,
          checkToShowHorizontalLine: (value) {
            // Toleransi perbedaan floating point pembagian decimal di Dart
            final isIntervalLine = (value % yInterval).abs() < 1.0;
            return value == minY || isIntervalLine || value == maxY;
          },
          getDrawingHorizontalLine: (value) =>
              FlLine(color: borderColor, strokeWidth: 1, dashArray: [4, 4]),
          drawVerticalLine: false,
        ),
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

          final double pem = dataBulan.pemasukan;
          final double peng = dataBulan.pengeluaran;

          return BarChartGroupData(
            x: index,
            barRods: [
              // Pemasukan (Dipertahankan warnanya)
              BarChartRodData(
                toY: pem,
                color: AppColors.black,
                width: 10,
                borderRadius: BorderRadius.circular(4),
              ),
              // Pengeluaran (Dipertahankan warnanya)
              BarChartRodData(
                toY: peng,
                color: const Color(0xFF9CA3AF),
                width: 10,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Format label sumbu Y: nilai di bawah 1 juta ditampilkan dalam "K",
/// nilai 1 juta ke atas ditampilkan dalam "M".
String _formatYLabel(double value) {
  if (value < 1000000) {
    return '${(value / 1000).toStringAsFixed(0)}K';
  }
  final juta = value / 1000000;
  final isWhole = juta == juta.roundToDouble();
  return isWhole
      ? '${juta.toStringAsFixed(0)}M'
      : '${juta.toStringAsFixed(1)}M';
}
