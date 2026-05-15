import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugas_akhir/controller/kalkulator_controller.dart';
 
class TotalTagihanBox extends StatelessWidget {
  final KalkulatorController ctrl;
 
  const TotalTagihanBox({super.key, required this.ctrl});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          const Text(
            'Total Tagihan',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            ctrl.totalFormatted,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}