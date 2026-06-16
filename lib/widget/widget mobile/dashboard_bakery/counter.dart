import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';
import 'package:tugas_akhir/models/resep.dart';

class BakeryBahanCounter extends StatelessWidget {
  final BakeryController ctrl;
  final Resep resep;
  const BakeryBahanCounter({super.key, required this.ctrl, required this.resep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Bahan-bahan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Obx(() => Row(
          children: [
            GestureDetector(
              onTap: () {
                if (ctrl.jumlahProduksi.value > 1) {
                  ctrl.jumlahProduksi.value--;
                  ctrl.inputController.text =
                      ctrl.jumlahProduksi.value.toString();
                  if (resep.id != null) ctrl.loadBakeryCalculation(resep.id!);
                }
              },
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.remove, size: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                ctrl.jumlahProduksi.value.toString(),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: () {
                ctrl.jumlahProduksi.value++;
                ctrl.inputController.text =
                    ctrl.jumlahProduksi.value.toString();
                if (resep.id != null) ctrl.loadBakeryCalculation(resep.id!);
              },
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE89336),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, size: 16, color: Colors.white),
              ),
            ),
          ],
        )),
      ],
    );
  }
}