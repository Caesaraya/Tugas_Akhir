import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin/keuangan_controller.dart';

class KomposisiPengeluaran extends StatelessWidget {
  const KomposisiPengeluaran({super.key});

  String _formatRupiah(double value) {
    // Format singkat: 84.200.000 → 84.2M, 1.500.000 → 1.5M, 500.000 → 500K
    String formatted;
    if (value.abs() >= 1000000000) {
      formatted = '${(value / 1000000000).toStringAsFixed(1)}B';
    } else if (value.abs() >= 1000000) {
      formatted = '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value.abs() >= 1000) {
      formatted = '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      formatted = value.toStringAsFixed(0);
    }
    return value < 0 ? '-Rp $formatted' : 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<KeuanganController>();

    // --- PALET MONO GRADASI BERURUTAN (GELAP KE TERANG) ---
    // Diatur berurutan dari tingkat kegelapan tinggi ke tingkat kecerahan tinggi
    // dengan selisih kontras yang kontras di setiap tingkatnya.
    final List<Color> palette = [
      const Color(0xFF1A1A1A), // 1. Hitam Pekat (Sangat Gelap)
      const Color(0xFF333333), // 2. Charcoal / Abu Tua Sekali
      const Color(0xFF4D4D4D), // 3. Abu-abu Tua
      const Color(0xFF666666), // 4. Slate Grey / Abu-abu Menengah
      const Color(0xFF808080), // 5. Abu-abu Semen
      const Color(0xFF999999), // 6. Abu-abu Menengah Terang
      const Color(0xFFB3B3B3), // 7. Silver / Abu-abu Terang
      const Color(0xFFCCCCCC), // 8. Abu-abu Sangat Terang
      const Color(0xFFE6E6E6), // 9. Platinum / Hampir Putih (Sangat Terang)
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- JUDUL ---
          const Text(
            "Komposisi Pengeluaran",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // --- BODY: Chart (kiri) + Legend (kanan) ---
          Expanded(
            child: Obx(() {
              double total = controller.keuangan.value.pengeluaran;
              var komposisi = controller.komposisiBulanIni;

              List<double> segments = [];
              List<Color> colorsUsed = [];
              List<MapEntry<String, double>> entries = [];
              int idx = 0;

              komposisi.forEach((key, value) {
                if (value > 0 && total > 0) {
                  segments.add(value / total);
                  colorsUsed.add(palette[idx % palette.length]);
                  entries.add(MapEntry(key, value));
                }
                idx++;
              });

              if (total == 0 || segments.isEmpty) {
                return const Center(
                  child: Text(
                    "Tidak ada data transaksi pengeluaran bulan ini",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Ukuran chart adaptif: ambil sisi terpendek, maks 160
                  final chartSize = min(
                    constraints.maxHeight,
                    constraints.maxWidth * 0.5,
                  ).clamp(80.0, 160.0);

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- DONUT CHART + TOTAL DI TENGAH ---
                      SizedBox(
                        width: chartSize,
                        height: chartSize,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: Size(chartSize, chartSize),
                              painter: _DonutChartPainter(
                                percentages: segments,
                                colors: colorsUsed,
                              ),
                            ),
                            // Teks total di tengah donut
                            Text(
                              _formatRupiah(total),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                // Font size responsif terhadap ukuran chart
                                fontSize: (chartSize * 0.13).clamp(11.0, 15.0),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 20),

                      // --- LEGEND (kanan chart) ---
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(entries.length, (i) {
                            final kategori = entries[i].key;
                            final nominal = entries[i].value;
                            final percentage = total > 0
                                ? (nominal / total) * 100
                                : 0.0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: colorsUsed[i],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      kategori,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF424242),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${percentage.toStringAsFixed(0)}%",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;
  _DonutChartPainter({required this.percentages, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2;
    final center = Offset(size.width / 2, size.height / 2);
    // strokeWidth adaptif: 18% dari diameter
    final double strokeW = size.width * 0.18;
    final radius = (min(size.width, size.height) - strokeW) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    for (int i = 0; i < percentages.length; i++) {
      final sweepAngle = percentages[i] * 2 * pi;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeW
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
