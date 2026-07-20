import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  final NumberFormat plainNumberFormat = NumberFormat.decimalPattern('id_ID');
  static const double maxInput = 99999999;
  static const double confirmationThreshold = 1000000; 
  String lastValidDigits = '';

  void onInputChanged(String value) {
    final clean = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (clean.isEmpty) {
      lastValidDigits = '';
      cartController.setInputUang('');
      return;
    }

    final nominal = double.tryParse(clean) ?? 0;

    if (nominal > maxInput) {
      final revertText = lastValidDigits.isEmpty
          ? ''
          : plainNumberFormat.format(int.parse(lastValidDigits));

      textController.value = TextEditingValue(
        text: revertText,
        selection: TextSelection.collapsed(offset: revertText.length),
      );

      showError(
        'Batas Maksimal',
        'Maksimal input Rp ${plainNumberFormat.format(maxInput)}',
      );
      return;
    }

    lastValidDigits = clean;
    cartController.setInputUang(clean);
  }

  Future<void> processPayment() async {
    if (!isUangCukup) {
      showError('Uang Kurang', 'Uang diterima belum mencukupi total tagihan');
      return;
    }

    final inputNominal =
        double.tryParse(
          textController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
    if (inputNominal > confirmationThreshold) {
      final confirmed = await confirmLargeCash(inputNominal);
      if (!confirmed) return;
    }

    cartController.selectedPayment.value = 'cash';
    cartController.inputUang.value = inputNominal;
    Get.offAllNamed(AppRoutes.sukses);
  }

  Future<bool> confirmLargeCash(double nominal) async {
    final formatted = cartController.currencyFormatter.format(nominal);
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Konfirmasi Nominal'),
        content: Text(
          'Uang diterima sebesar $formatted. Pastikan nominal sudah '
          'benar sebelum melanjutkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal, Cek Lagi'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE89336),
            ),
            child: const Text(
              'Ya, Sudah Benar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result ?? false;
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