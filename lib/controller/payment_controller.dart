import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
 
class PaymentController extends GetxController {
  var input = ''.obs;
  var selectedMethod = 'cash'.obs;
 
  final CartController cartController = Get.find<CartController>();
 

  static final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
 
  static String formatRupiah(num value) => currencyFormatter.format(value);
 
 
  String get totalFormatted =>
      formatRupiah(cartController.totalPrice);
 

  String get inputFormatted =>
      formatRupiah(double.tryParse(input.value) ?? 0);
 

  String get methodLabel => selectedMethod.value;
 

  double get paidAmount => double.tryParse(input.value) ?? 0;
 

  double get changeAmount {
    final change = paidAmount - cartController.totalPrice;
    return change > 0 ? change : 0;
  }
 

  void onButtonPressed(String value) {
    if (value == 'X') {
      if (input.value.isNotEmpty) {
        input.value = input.value.substring(0, input.value.length - 1);
      }
    } else if (value == 'CLEAR') {
      input.value = '';
    } else {
      if (input.value.length < 12) {
        if (input.value.isEmpty && (value == '0' || value == '000')) return;
        input.value += value;
      }
    }
  }
 
  void onPaymentMethodChanged(String? value) {
    if (value != null) selectedMethod.value = value;
  }
 

  void processPayment() {
    if (selectedMethod.value.isEmpty) {
      showWarning(
        'Pilih Metode',
        'Silakan pilih metode pembayaran terlebih dahulu!',
      );
      return;
    }
 
    if (paidAmount < cartController.totalPrice) {
      showError('Pembayaran Gagal', 'Uang yang dimasukkan kurang!');
    } else {
      cartController.selectedPayment.value = selectedMethod.value;
      cartController.inputUang.value = paidAmount;
      Get.offAllNamed(AppRoutes.kasirprint);
    }
  }
 

  void showWarning(String title, String msg) {
    Get.snackbar(
      title, msg,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }

  void showError(String title, String msg) {
    Get.snackbar(
      title, msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }
}