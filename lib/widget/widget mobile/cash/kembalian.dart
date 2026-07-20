import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/kalkulator_controller.dart';
import 'package:get/get.dart';

class KembalianDisplay extends StatelessWidget {
  final KalkulatorController ctrl;

  const KembalianDisplay({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'Kembalian',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Obx(
            () => FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                ctrl.kembalianFormatted,
                maxLines: 1,
                softWrap: false,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: ctrl.isUangCukup ? Colors.green : Colors.red[300],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}