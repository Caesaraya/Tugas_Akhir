import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/models/financial_report.dart';
import 'package:tugas_akhir/utils/app_color.dart';

/// Widget grafik "Pemasukan vs Pengeluaran" khusus untuk Dashboard Mobile.
///
/// Ditampilkan dalam bentuk Multiple Horizontal Bar Chart per bulan agar
/// lebih mudah dibaca di layar kecil dibanding versi Column Chart
/// (`DashboardChart`) yang dipakai pada Dashboard Desktop.
///
/// Data yang digunakan tetap berasal dari backend (`controller.filteredReports`),
/// tidak ada dummy data. Nominal selalu ditampilkan menggunakan format Rupiah.
class DashboardChartMobile extends StatelessWidget {
  final List<FinancialReport> reports;

  const DashboardChartMobile({Key? key, required this.reports})
    : super(key: key);

  static const double _labelWidth = 82;
  static const double _valueWidth = 90;
  static const double _barHeight = 20;

  static const Color _pemasukanColor = AppColors.black;
  static const Color _pengeluaranColor = Color(0xFF9CA3AF);
  static const Color _trackColor = Color(0xFFF1F1F1);
  static const Color _secondaryTextColor = Color(0xFF6B7280);

  static const List<String> _listBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  // Formatter Rupiah tanpa spasi & tanpa desimal, contoh: Rp100.000
  String _formatRupiah(num value) {
    final formatter = NumberFormat('#,##0', 'id_ID');
    return 'Rp${formatter.format(value)}';
  }

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Belum ada data keuangan',
            style: TextStyle(color: _secondaryTextColor, fontSize: 13),
          ),
        ),
      );
    }

    final sortedReports = List<FinancialReport>.from(reports)
      ..sort((a, b) => a.bulan.compareTo(b.bulan));

    final maxValue = sortedReports.fold<double>(0, (prev, r) {
      final localMax = r.pemasukan > r.pengeluaran
          ? r.pemasukan
          : r.pengeluaran;
      return localMax > prev ? localMax : prev;
    });
    final safeMaxValue = maxValue <= 0 ? 1.0 : maxValue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < sortedReports.length; i++) ...[
          _buildMonthGroup(sortedReports[i], safeMaxValue),
          if (i != sortedReports.length - 1) const SizedBox(height: 18),
        ],
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  Widget _buildMonthGroup(FinancialReport report, double maxValue) {
    final bulanIndex = report.bulan - 1;
    final namaBulan = (bulanIndex >= 0 && bulanIndex < 12)
        ? _listBulan[bulanIndex]
        : 'Bulan ${report.bulan}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          namaBulan,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        _buildBarRow(
          label: 'Pemasukan',
          value: report.pemasukan,
          maxValue: maxValue,
          color: _pemasukanColor,
        ),
        const SizedBox(height: 6),
        _buildBarRow(
          label: 'Pengeluaran',
          value: report.pengeluaran,
          maxValue: maxValue,
          color: _pengeluaranColor,
        ),
      ],
    );
  }

  Widget _buildBarRow({
    required String label,
    required double value,
    required double maxValue,
    required Color color,
  }) {
    final fraction = (value / maxValue).clamp(0.0, 1.0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: _labelWidth,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: _secondaryTextColor),
          ),
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final targetWidth = fraction * maxWidth;

              return Tooltip(
                message: _formatRupiah(value),
                triggerMode: TooltipTriggerMode.tap,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // Track / background bar
                    Container(
                      height: _barHeight,
                      width: maxWidth,
                      decoration: BoxDecoration(
                        color: _trackColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    // Bar aktual dengan animasi tumbuh dari 0 -> nilai target
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: targetWidth),
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeOutCubic,
                      builder: (context, width, child) {
                        return Container(
                          height: _barHeight,
                          width: width,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: _valueWidth,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              _formatRupiah(value),
              maxLines: 1,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Pemasukan', _pemasukanColor),
        const SizedBox(width: 20),
        _buildLegendItem('Pengeluaran', _pengeluaranColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: _secondaryTextColor),
        ),
      ],
    );
  }
}
