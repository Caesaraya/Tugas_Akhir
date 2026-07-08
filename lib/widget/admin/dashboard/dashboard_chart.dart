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

    // Konfigurasi Batas Sesuai Instruksi
    double minY = 100000; // Minimal 100 Ribu
    double maxY = 9000000; // Maksimal 9 Juta

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
              // Menggunakan checkToShowHorizontalLine untuk kebebasan posisi garis
              interval: 1000000,
              getTitlesWidget: (value, meta) {
                if (value < minY || value > maxY) {
                  return const SizedBox.shrink();
                }

                String labelText = '';
                if (value == 100000) {
                  labelText = '100K';
                } else {
                  final juta = value / 1000000;
                  labelText = '${juta.toStringAsFixed(0)}M';
                }

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
          // Menampilkan garis grid tepat pada nilai minimal (100rb) dan setiap kelipatan 1 juta
          checkToShowHorizontalLine: (value) =>
              value == 100000 || value % 1000000 == 0,
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
              // Pemasukan
              BarChartRodData(
                toY: pem,
                color: AppColors.black,
                width: 10,
                borderRadius: BorderRadius.circular(4),
              ),
              // Pengeluaran
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
