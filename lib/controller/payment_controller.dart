import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/midtrans_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/keranjang/delete_validation.dart';

class PaymentController extends GetxController {
  var input = ''.obs;
  var selectedMethod = 'cash'.obs;

  final CartController cartController = Get.find<CartController>();

  static const double maxCashInput = 99999999;

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

  String get methodLabel => selectedMethod.value;

  double get paidAmount => double.tryParse(input.value) ?? 0;

  double get changeAmount {
    final change = paidAmount - cartController.totalPrice;
    return change > 0 ? change : 0;
  }

  void increaseQty(int productId) {
    final item = cartController.cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null && item.qty >= item.stock) {
      showWarning('Stok Terbatas', 'Stok maksimal ${item.stock}');
      return;
    }
    cartController.increaseQty(productId);
  }

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

  // ── Desktop numpad ────────────────────────────────────────────────────────
  void onButtonPressed(String value) {
    if (selectedMethod.value != 'cash') {
      showWarning('Info', 'Input angka hanya untuk metode Cash');
      return;
    }

    if (value == 'X') {
      if (input.value.isNotEmpty) {
        input.value = input.value.substring(0, input.value.length - 1);
      }
    } else if (value == 'CLEAR') {
      input.value = '';
    } else {
      if (input.value.length < 12) {
        if (input.value.isEmpty && (value == '0' || value == '000')) return;
        final newInput = input.value + value;
        final nominal = double.tryParse(newInput) ?? 0;
        if (nominal > maxCashInput) {
          showWarning('Batas Maksimal', 'Maksimal input cash Rp 99.999.999');
          return;
        }
        input.value = newInput;
      }
    }
  }

  void onPaymentMethodChanged(String? value) {
    if (value != null) {
      selectedMethod.value = value;
      input.value = ''; // clear input saat ganti metode
    }
  }

  // ── Desktop — process payment ─────────────────────────────────────────────
  void processPayment() {
    if (selectedMethod.value.isEmpty) {
      showWarning('Pilih Metode', 'Silakan pilih metode pembayaran!');
      return;
    }

    if (selectedMethod.value == 'cash') {
      if (paidAmount <= 0) {
        showError('Input Kosong', 'Masukkan jumlah uang yang diterima');
        return;
      }
      if (paidAmount < cartController.totalPrice) {
        showError('Pembayaran Gagal', 'Uang yang dimasukkan kurang!');
        return;
      }
      cartController.selectedPayment.value = 'cash';
      cartController.inputUang.value = paidAmount;
      Get.offAllNamed(AppRoutes.kasirprint);
    } else {
      // QRIS / VA → Midtrans desktop
      prosesMidtransDesktop();
    }
  }

  Future<void> prosesMidtransDesktop() async {
    try {
      final BuyController buyCtrl = Get.put(BuyController());
      final int total = cartController.totalPrice.toInt();
      final String title = cartController.cartItems
          .map((item) => item.name)
          .join(', ');

      // ← Set metode dan amount sebelum proses
      cartController.selectedPayment.value = selectedMethod.value;
      cartController.inputUang.value = cartController.totalPrice;

      await buyCtrl.checkout(
        title: title.isEmpty ? 'Pembayaran' : title,
        amount: total,
        isDesktop: true,
      );
    } catch (e) {
      showError('Error', 'Gagal memproses pembayaran: $e');
    }
  }

void bayarSekarang() {
  // ← Pakai cartController.selectedPayment yang diupdate UI
  final metode = cartController.selectedPayment.value;

  if (metode == 'cash') {
    Get.toNamed(AppRoutes.kalkulator);
  } else {
    prosesMidtransMobile();
  }
}

Future<void> prosesMidtransMobile() async {
  try {
    final BuyController buyCtrl = Get.put(BuyController());
    final int total = cartController.totalPrice.toInt();
    final String title = cartController.cartItems
        .map((item) => item.name)
        .join(', ');

    cartController.inputUang.value = cartController.totalPrice;

    await buyCtrl.checkout(
      title: title.isEmpty ? 'Pembayaran' : title,
      amount: total,
      isDesktop: false,
    );
  } catch (e) {
    showError('Error', 'Gagal memproses pembayaran: $e');
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