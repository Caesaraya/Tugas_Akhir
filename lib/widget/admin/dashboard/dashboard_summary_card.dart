import 'package:flutter/material.dart';
import 'package:tugas_akhir/utils/app_color.dart';

class DashboardSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final bool isPositive;
  final List<Color> sparklineColors;

  const DashboardSummaryCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.isPositive,
    required this.sparklineColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE5E7EB);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Deteksi lebar ruang yang tersedia untuk card ini
        final double availableWidth = constraints.maxWidth;

        // Atur ukuran padding dan font secara dinamis/adaptif berdasarkan lebar card
        final double paddingValue = availableWidth < 160 ? 12.0 : 16.0;
        final double titleFontSize = availableWidth < 160 ? 11.0 : 13.0;
        final double valueFontSize = availableWidth < 160 ? 14.0 : 16.0;
        final double subtitleFontSize = availableWidth < 160 ? 10.0 : 12.0;

        // Atur ukuran Sparkline Container secara proporsional agar tidak mendorong teks keluar
        final double sparklineWidth = availableWidth < 160 ? 40.0 : 55.0;
        final double sparklineHeight = availableWidth < 160 ? 12.0 : 16.0;

        return Container(
          padding: EdgeInsets.all(paddingValue),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Menyebarkan konten vertikal secara rapi & pas
            children: [
              // 1. Bagian Judul Card
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),

              // 2. Bagian Nilai Utama (Value)
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 6),

              // 3. Bagian Bawah: Baris Subtitle & Sparkline Grafik Kecil
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menggunakan Flexible agar teks teks panjang otomatis terpotong (ellipsis)
                  // dan tidak akan pernah mendorong grafik keluar dari area Card
                  Flexible(
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w500,
                        color: isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Sparkline adaptif yang ukurannya mengecil di layar HP sempit
                  Container(
                    width: sparklineWidth,
                    height: sparklineHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: LinearGradient(colors: sparklineColors),
                    ),
                    child: CustomPaint(
                      painter: _SparklinePainter(isPositive: isPositive),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final bool isPositive;
  _SparklinePainter({required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? const Color(0xFF10B981) : const Color(0xFFEF4444)
      ..style = PaintingStyle.stroke
      ..strokeWidth =
          1.5; // Ketebalan disesuaikan agar tetap presisi saat mengecil

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.lineTo(size.width * 0.3, size.height * 0.6);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.4);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
