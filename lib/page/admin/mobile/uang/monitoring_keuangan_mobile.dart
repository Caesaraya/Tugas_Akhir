import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/keuangan_controller.dart';
import 'package:tugas_akhir/utils/app_color.dart';
import 'package:tugas_akhir/widget/admin/dialogs/uang/dialog_tambah_pengeluaran.dart';
import 'package:tugas_akhir/widget/admin/mobile_admin_drawer.dart';
import 'package:tugas_akhir/widget/admin/uang/card_keuangan.dart';
import 'package:tugas_akhir/widget/admin/uang/komposisi_pengeluaran.dart';

// ==================== SPARKLINE PAINTER ====================
class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    if (range == 0) return;

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final normalizedValue = (data[i] - minValue) / range;
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      data != oldDelegate.data || color != oldDelegate.color;
}

class MonitoringKeuanganMobilePage extends StatelessWidget {
  MonitoringKeuanganMobilePage({super.key});

  final controller = Get.find<KeuanganController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MobileAdminDrawer(),
      backgroundColor: const Color(0xFFF5F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Monitoring Keuangan',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================== TITLE SECTION ====================
              _buildTitleSection(),

              const SizedBox(height: 20),

              // ==================== SUMMARY CARDS ====================
              _buildSummaryCards(),

              const SizedBox(height: 20),

              // ==================== EXPENSE COMPOSITION ====================
              // Mengatur tinggi statis agar Donut Chart & Legend bisa merender data Bahan Baku dengan aman
              const SizedBox(height: 280, child: KomposisiPengeluaran()),

              const SizedBox(height: 20),

              // BUTTON TAMBAH PENGELUARAN (Pindah ke sini agar tidak merusak layout)
              _buildAddExpenseButton(context),

              const SizedBox(height: 24),

              // ==================== MONTHLY RECAP ====================
              _buildMonthlyRecapSection(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== WIDGETS ====================

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Financial Overview',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              _buildMonthSelector(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        DateFormat('MMM yyyy').format(DateTime.now()).toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildSkeletonCards();
        }

        final data = controller.keuangan.value;

        return Column(
          children: [
            // TOTAL INCOME
            _buildSummaryCardWithBadge(
              title: 'TOTAL INCOME',
              amount: data.pemasukan,
              subtitle: 'Total omset bulan ini',
              icon: Icons.account_balance_wallet_outlined,
              accentColor: Colors.blue,
              changePercent: 12.4,
              isPositive: true,
            ),

            const SizedBox(height: 12),

            // TOTAL EXPENSE
            _buildSummaryCardWithBadge(
              title: 'TOTAL EXPENSE',
              amount: data.pengeluaran,
              subtitle: 'Estimasi pengeluaran',
              icon: Icons.shopping_cart_outlined,
              accentColor: Colors.orange,
              changePercent: -8.2,
              isPositive: false,
            ),

            const SizedBox(height: 12),

            // NET PROFIT
            _buildSummaryCardWithBadge(
              title: 'NET PROFIT',
              amount: data.profit,
              subtitle: 'Keuntungan setelah dipotong',
              icon: Icons.trending_up,
              accentColor: Colors.green,
              changePercent: 15.1,
              isPositive: true,
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCardWithBadge({
    required String title,
    required double amount,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required double changePercent,
    required bool isPositive,
  }) {
    final rupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    final badgeColor = isPositive
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);
    final badgeTextColor = isPositive
        ? const Color(0xFF2E7D32)
        : const Color(0xFFC62828);
    final badgeIcon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title + Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: Colors.grey.shade600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, size: 12, color: badgeTextColor),
                    const SizedBox(width: 4),
                    Text(
                      '${isPositive ? '+' : ''}${changePercent.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: badgeTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Amount
          Text(
            rupiah.format(amount),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          // Bottom Row: Subtitle + Icon + Sparkline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sparkline Mini Chart
                  SizedBox(
                    width: 50,
                    height: 28,
                    child: CustomPaint(
                      painter: _SparklinePainter(
                        data: _generateSparklineData(amount),
                        color: accentColor.withOpacity(0.7),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: accentColor.withOpacity(0.6),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<double> _generateSparklineData(double amount) {
    // Generate simple sparkline data based on amount
    // This creates a simple upward trend
    return [
      amount * 0.6,
      amount * 0.65,
      amount * 0.7,
      amount * 0.75,
      amount * 0.8,
      amount * 0.9,
      amount * 0.95,
    ];
  }

  Widget _buildSkeletonCards() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < 2 ? 12 : 0),
          child: Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCompositionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const KomposisiPengeluaran(),
      ),
    );
  }

  Widget _buildAddExpenseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => const DialogTambahPengeluaran(),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFE65100).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Tambah Pengeluaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== MONTHLY RECAP SECTION ====================

  Widget _buildMonthlyRecapSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title + Year Dropdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Rekap Keuangan Bulanan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              _buildYearDropdown(),
            ],
          ),
          const SizedBox(height: 12),

          // Card List
          Obx(() {
            if (controller.isLoading.value &&
                controller.filteredReports.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFE65100)),
              );
            }

            if (controller.filteredReports.isEmpty) {
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Text(
                  'Tidak ada data',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                ),
              );
            }

            return Column(
              children: controller.filteredReports
                  .map((report) => _buildMonthlyCard(report))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildYearDropdown() {
    return Obx(
      () => Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedYear.value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            items: controller.availableYears.map((int year) {
              return DropdownMenuItem<int>(
                value: year,
                child: Text("Tahun $year"),
              );
            }).toList(),
            onChanged: (int? newValue) {
              if (newValue != null) controller.changeYear(newValue);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyCard(dynamic report) {
    String formatRupiah(double value) {
      String result = value
          .abs()
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          );
      return value < 0 ? '-Rp $result' : 'Rp $result';
    }

    final profitColor = report.profit < 0
        ? const Color(0xFFC62828)
        : (report.profit > 0 ? const Color(0xFF2E7D32) : Colors.black);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Header
          Text(
            report.bulanNama,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),

          // Income Row
          _buildMonthlyRow(
            label: 'Pemasukan',
            value: formatRupiah(report.pemasukan),
            valueColor: Colors.black,
          ),
          const SizedBox(height: 8),

          // Expense Row
          _buildMonthlyRow(
            label: 'Pengeluaran',
            value: formatRupiah(report.pengeluaran),
            valueColor: Colors.black,
          ),
          const SizedBox(height: 8),

          // Profit Row (colored)
          _buildMonthlyRow(
            label: 'Profit',
            value: formatRupiah(report.profit),
            valueColor: profitColor,
          ),
          const SizedBox(height: 8),

          // Transaction Count Row
          _buildMonthlyRow(
            label: 'Total Transaksi',
            value: report.totalTransaksi.toString(),
            valueColor: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyRow({
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
