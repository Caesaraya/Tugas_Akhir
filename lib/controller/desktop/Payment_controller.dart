import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/routes/routes.dart';
import '../cart_controller.dart';

class PaymentController extends GetxController {
  var input = "".obs;
  var selectedMethod = "cash".obs;

  // Mendapatkan instance CartController yang sudah ada
  final CartController cartController = Get.find<CartController>();

  void onButtonPressed(String value) {
    if (value == "X") {
      if (input.value.isNotEmpty) {
        input.value = input.value.substring(0, input.value.length - 1);
      }
    } else if (value == "CLEAR") {
      input.value = "";
    } else {
      if (input.value.length < 12) {
        if (input.value.isEmpty && (value == "0" || value == "000")) return;
        input.value += value;
      }
    }
  }

  void onPaymentMethodChanged(String? value) {
    if (value != null) selectedMethod.value = value;
  }

  /// LOGIKA UTAMA PEMBAYARAN (Cleaned dari UI)
  void processPayment() {
    double nominalInput = double.tryParse(input.value) ?? 0;
    double totalTagihan = cartController.totalPrice;

    if (selectedMethod.value.isEmpty) {
      _showWarning("Pilih Metode", "Silakan pilih metode pembayaran terlebih dahulu!");
      return;
    }

    if (nominalInput < totalTagihan) {
      _showError("Pembayaran Gagal", "Uang yang dimasukkan kurang!");
    } else {
      cartController.selectedPayment.value = selectedMethod.value;
      cartController.inputUang.value = nominalInput;
      Get.offAllNamed(AppRoutes.kasirprint);
    }
  }

  // Helper Snackbar agar kode di atas tidak berulang
  void _showWarning(String title, String msg) {
    Get.snackbar(title, msg, backgroundColor: Colors.orange, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }

  void _showError(String title, String msg) {
    Get.snackbar(title, msg, backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
  }
}