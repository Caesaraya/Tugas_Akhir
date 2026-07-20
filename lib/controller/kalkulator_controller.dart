import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

class KalkulatorController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  String get totalFormatted =>
      cartController.currencyFormatter.format(cartController.totalPrice);

  String get kembalianFormatted =>
      cartController.currencyFormatter.format(cartController.kembalian);

  bool get isUangCukup => cartController.isUangCukup;
  bool get hasInputUang => cartController.hasInputUang;

  TextEditingController get textController => cartController.textController;

  static const double maxInput = 10000000; 

  void onInputChanged(String value) {
    final clean = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (clean.isEmpty) {
      cartController.setInputUang('');
      return;
    }

    final nominal = double.tryParse(clean) ?? 0;
    if (nominal > maxInput) {
      final maxStr = maxInput.toInt().toString();
      cartController.setInputUang(maxStr);

      final formatted = cartController.currencyFormatter.format(maxInput);
      textController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );

      showError('Batas Maksimal', 'Input maksimal Rp 10.000.000');
      return;
    }
    cartController.setInputUang(clean);
  }

  void processPayment() {
    if (!isUangCukup) {
      showError('Uang Kurang', 'Uang diterima belum mencukupi total tagihan');
      return;
    }
    cartController.selectedPayment.value = 'cash';
    cartController.inputUang.value =
        double.tryParse(
          textController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    Get.offAllNamed(AppRoutes.sukses);
  }

  void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }
}
