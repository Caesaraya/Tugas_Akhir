import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/kalkulator_controller.dart';
import 'package:get/get.dart';

class KonfirmasiBayarButton extends StatelessWidget {
  final KalkulatorController ctrl;
 
  const KonfirmasiBayarButton({super.key, required this.ctrl});
 
  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ctrl.hasInputUang
                  ? const Color(0xFFE89336)
                  : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 0,
            ),
            onPressed: ctrl.hasInputUang ? ctrl.processPayment : null,
            child: const Text(
              'Konfirmasi & Bayar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ));
  }
}