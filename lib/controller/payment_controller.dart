import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/delete_validation.dart';
 
class PaymentController extends GetxController {
  var input = ''.obs;
  var selectedMethod = 'cash'.obs;
 
  final CartController cartController = Get.find<CartController>();
 
  // ─── Getter format currency — pakai CartController ────────────────────────
  String get totalFormatted =>
      cartController.currencyFormatter.format(cartController.totalPrice);
 
  String get inputFormatted =>
      cartController.currencyFormatter.format(
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
    final double hargaDiskon =
        (hargaAsli - (hargaAsli * persen / 100)).roundToDouble();
    return cartController.currencyFormatter.format(hargaDiskon * item.qty);
  }
 
  // ─── Getter payment ───────────────────────────────────────────────────────
  String get methodLabel => selectedMethod.value;
 
  double get paidAmount => double.tryParse(input.value) ?? 0;
 
  double get changeAmount {
    final change = paidAmount - cartController.totalPrice;
    return change > 0 ? change : 0;
  }
 
  // ─── Aksi qty keranjang ───────────────────────────────────────────────────
  void increaseQty(int productId) => cartController.increaseQty(productId);
  void decreaseQty(int productId) => cartController.decreaseQty(productId);
 
  void removeItem(dynamic item) {
    DeleteValidation.show(
      productName: item.name,
      onConfirm: () {
        cartController.removeFromCart(item.productId);
        Get.back();
        Get.snackbar(
          'Berhasil',
          '${item.name} dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(15),
        );
      },
    );
  }
 
  // ─── Input numpad (desktop) ───────────────────────────────────────────────
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
 
  // ─── Ganti metode pembayaran ──────────────────────────────────────────────
  void onPaymentMethodChanged(String? value) {
    if (value != null) selectedMethod.value = value;
  }
 
  // ─── Proses bayar desktop → kasirprint ───────────────────────────────────
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
 
  // ─── Proses bayar mobile ──────────────────────────────────────────────────
  void bayarSekarang() {
    if (cartController.selectedPayment.value == 'cash') {
      Get.toNamed(AppRoutes.kalkulator);
    } else {
      cartController.inputUang.value = cartController.totalPrice;
      Get.toNamed(AppRoutes.sukses);
    }
  }
 
  // ─── Snackbar helpers ─────────────────────────────────────────────────────
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