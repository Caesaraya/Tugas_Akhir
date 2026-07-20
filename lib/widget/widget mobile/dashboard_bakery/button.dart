import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';
import 'package:tugas_akhir/models/resep.dart';
import 'package:tugas_akhir/page/mobile/bakery_production_preview.dart';

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
            color: Colors.black.withAlpha(
              20,
            ),
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
                  if (ctrl.selectedResep.value != null) {
                    Get.to(() => const BakeryProductionPreviewPage());
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE89336),
            minimumSize: const Size(double.infinity, 52),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
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
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.calculate_outlined,
                          color: Colors.white,
                        ),
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
