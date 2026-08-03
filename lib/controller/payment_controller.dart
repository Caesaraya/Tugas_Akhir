import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/keranjang/delete_validation.dart';

class PaymentController extends GetxController {
  var input = ''.obs;
  var selectedMethod = 'cash'.obs;
  static const double maxCashInput = 99999999;

  final CartController cartController = Get.find<CartController>();

  String get totalFormatted =>
      cartController.currencyFormatter.format(cartController.totalPrice);

  String get inputFormatted => cartController.currencyFormatter.format(
    double.tryParse(input.value) ?? 0,
  );

  String get subtotalFormatted =>
      cartController.currencyFormatter.format(cartController.subtotal);

  String get diskonFormatted =>
      '- ${cartController.currencyFormatter.format(cartController.totalDiscount)}';

  bool get hasDiskon => cartController.totalDiscount > 0;

  String itemTotalFormatted(dynamic item) {
    final double hargaAsli = item.price.toDouble();
    final double persen = (item.discount ?? 0).toDouble();
    final double hargaDiskon = (hargaAsli - (hargaAsli * persen / 100))
        .roundToDouble();
    return cartController.currencyFormatter.format(hargaDiskon * item.qty);
  }

  void onButtonPressed(String text) {
    if (text == 'C') {
      input.value = '';
    } else if (text == '⌫') {
      if (input.value.isNotEmpty) {
        input.value = input.value.substring(0, input.value.length - 1);
      }
    } else {
      if (input.value.length >= 8) return;
      if (input.value == '0' && text == '0') return;
      if (input.value == '' && (text == '00' || text == '000')) return;

      String newInputValue = input.value + text;
      double newAmount = double.tryParse(newInputValue) ?? 0;

      if (newAmount > maxCashInput) {
        showWarning(
          'Batas Maksimal',
          'Nominal tidak boleh melebihi Rp 99.999.999',
        );
        return;
      }

      input.value = newInputValue;
    }
  }

  /// Fungsi untuk memilih metode pembayaran
  void selectPaymentMethod(String method) {
    selectedMethod.value = method;
    if (method != 'cash') {
      input.value = '';
    }
  }

  /// Alias/Getter/Callback untuk kompatibilitas dengan UI widget
  void onPaymentMethodChanged(String method) {
    selectPaymentMethod(method);
  }

  /// Memproses pembayaran dari tampilan Desktop
  void processPayment() {
    // Arahkan ke halaman QRIS jika metode yang dipilih adalah QRIS
    if (selectedMethod.value == 'qris') {
      cartController.selectedPayment.value = 'qris';
      Get.toNamed(AppRoutes.qrisPayment);
      return;
    }

    // Alur pembayaran Cash
    if (selectedMethod.value == 'cash') {
      double paidAmount = double.tryParse(input.value) ?? 0;
      if (paidAmount <= 0) {
        showError('Pembayaran Gagal', 'Masukkan jumlah uang yang diterima');
        return;
      }
      if (paidAmount < cartController.totalPrice) {
        showError('Pembayaran Gagal', 'Uang yang dimasukkan kurang!');
        return;
      }

      cartController.selectedPayment.value = selectedMethod.value;
      cartController.inputUang.value = paidAmount;
      Get.offAllNamed(AppRoutes.kasirprint);
      return;
    }

    // Metode pembayaran lainnya
    cartController.selectedPayment.value = selectedMethod.value;
    cartController.inputUang.value = cartController.totalPrice;
    Get.offAllNamed(AppRoutes.kasirprint);
  }

  /// Memproses pembayaran dari tampilan Mobile
  void bayarSekarang() {
    if (cartController.selectedPayment.value == 'cash') {
      Get.toNamed(AppRoutes.kalkulator);
    } else if (cartController.selectedPayment.value == 'qris') {
      Get.toNamed(AppRoutes.qrisPayment);
    } else {
      cartController.inputUang.value = cartController.totalPrice;
      Get.toNamed(AppRoutes.sukses);
    }
  }

  void showError(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }

  void showWarning(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }

  void showStockWarning(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
    );
  }
}
