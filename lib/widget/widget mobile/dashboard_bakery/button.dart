import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';
import 'package:tugas_akhir/models/resep.dart';

class BakeryEstimasiButton extends StatelessWidget {
  final BakeryController ctrl;
  final Resep resep;
  const BakeryEstimasiButton({
    super.key,
    required this.ctrl,
    required this.resep,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(
        () => ElevatedButton(
          onPressed: ctrl.isLoading.value
              ? null
              : () async {
                  if (resep.id == null) return;
                  await ctrl.loadBakeryCalculation(resep.id!);

                  // ── Tampilkan hasil estimasi ──────────────────────
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      title: const Text(
                        'Hasil Estimasi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Total biaya
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF3E0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Biaya Produksi',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                const SizedBox(height: 4),
                                Obx(() => Text(
                                      ctrl.totalBiayaFormatted,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFE89336),
                                      ),
                                    )),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Status bahan
                          Obx(() => Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: ctrl.semuaBahanCukup.value
                                      ? Colors.green.shade50
                                      : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: ctrl.semuaBahanCukup.value
                                        ? Colors.green.shade200
                                        : Colors.red.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      ctrl.semuaBahanCukup.value
                                          ? Icons.check_circle_outline
                                          : Icons.warning_amber_outlined,
                                      color: ctrl.semuaBahanCukup.value
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      ctrl.semuaBahanCukup.value
                                          ? 'Semua bahan cukup'
                                          : 'Bahan tidak cukup',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: ctrl.semuaBahanCukup.value
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Get.back(); // tutup dialog
                            Get.back(); // kembali ke dashboard bakery
                          },
                          child: const Text(
                            'Kembali',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE89336),
            minimumSize: const Size(double.infinity, 52),
            padding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ctrl.isLoading.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.calculate_outlined,
                          color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    ctrl.isLoading.value ? 'Memproses...' : 'Hitung Estimasi',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.chevron_right, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}