  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugas_akhir/controller/kalkulator_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/cash/CurrencyInputFormatter.dart';
import 'package:tugas_akhir/widget/widget mobile/cash/kalkulator_input.dart';

class UangDiterimaInput extends StatelessWidget {
  final KalkulatorController ctrl;
 
  const UangDiterimaInput({super.key, required this.ctrl});
 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Masukkan Uang Diterima',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        KalkulatorInput(
          controller: ctrl.textController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyInputFormatter(),
          ],
          onChanged: ctrl.onInputChanged,
        ),
      ],
    );
  }
}