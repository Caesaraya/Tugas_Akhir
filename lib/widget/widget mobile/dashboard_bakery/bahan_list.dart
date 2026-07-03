import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';
import 'package:tugas_akhir/models/resep.dart';

class BakeryBahanList extends StatelessWidget {
  final BakeryController ctrl;
  final Resep resep;
  const BakeryBahanList({super.key, required this.ctrl, required this.resep});

  @override
  Widget build(BuildContext context) {
    if (resep.bahan == null || resep.bahan!.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Text('Tidak ada bahan',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Column(
      children: resep.bahan!.map((bahan) {
        return Obx(() {
          final kebutuhan = ctrl.kebutuhanBahan(bahan.jumlahBahan);
          final qty =
              '${kebutuhan % 1 == 0 ? kebutuhan.toInt() : kebutuhan.toStringAsFixed(2)} ${bahan.satuan ?? ''}';

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE89336),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bahan.namaBahan ?? '-',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      if (bahan.merk != null && bahan.merk!.isNotEmpty)
                        Text(bahan.merk!,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                ),
                Text(qty,
                    style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          );
        });
      }).toList(),
    );
  }
}