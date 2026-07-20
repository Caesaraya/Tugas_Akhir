import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/kalkulator_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/cash/button_confirm.dart';
import 'package:tugas_akhir/widget/widget mobile/cash/kembalian.dart';
import 'package:tugas_akhir/widget/widget mobile/cash/total_tagihan.dart';
import 'package:tugas_akhir/widget/widget mobile/cash/uang_diterima.dart';

class KalkulatorCashPage extends StatelessWidget {
  const KalkulatorCashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final KalkulatorController kalkulatorController = Get.find<KalkulatorController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pembayaran Tunai',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: Get.back,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TotalTagihanBox(ctrl: kalkulatorController),
                  const SizedBox(height: 40),

                  UangDiterimaInput(ctrl: kalkulatorController),
                  const SizedBox(height: 60),

                  KembalianDisplay(ctrl: kalkulatorController),
                ],
              ),
            ),
          ),
         SafeArea(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
    child: KonfirmasiBayarButton(ctrl: kalkulatorController),
  ),
),
        ],
      ),
    );
  }
}
