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
 
  void onInputChanged(String value) {
    final clean = value.replaceAll('.', '');
    cartController.setInputUang(clean);
  }
 
  void processPayment() {
    if (!isUangCukup) {
      showError(
        'Uang Kurang',
        'Uang diterima belum mencukupi total tagihan',
      );
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
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.warning, color: Colors.white),
    );
  }
}