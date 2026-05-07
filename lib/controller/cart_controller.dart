import 'package:get/get.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:intl/intl.dart'; // Wajib untuk format titik

class CartController extends GetxController {
  final textController = TextEditingController();

  var cartItems = <CartItem>[].obs;
  var selectedPayment = 'cash'.obs;
  var inputUang = 0.0.obs;

  // Formatter untuk tampilan (misal: 100.000)
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  // ==========================================
  // LOGIKA KERANJANG & TRANSAKSI
  // ==========================================

  void addToCart(Product product) {
    var existingItem = cartItems.firstWhereOrNull(
      (item) => item.productId == product.id,
    );
    if (existingItem != null) {
      existingItem.qty++;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          productId: product.id,
          name: product.name,
          price: product.price,
          discount: product.discount,
          qty: 1,
        ),
      );
    }
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.productId == productId);
  }

  void increaseQty(int productId) {
    var item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null) {
      item.qty++;
      cartItems.refresh();
    }
  }

  void decreaseQty(int productId) {
    var item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null) {
      if (item.qty > 1) {
        item.qty--;
      } else {
        removeFromCart(productId);
      }
      cartItems.refresh();
    }
  }

  void setInputUang(String value) {
    if (value.isEmpty) {
      inputUang.value = 0;
    } else {
      // Menghapus semua karakter non-angka (seperti titik dari formatter) sebelum parsing
      inputUang.value = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }
  }

  void clearCart() {
    cartItems.clear();
    selectedPayment.value = 'cash';
    inputUang.value = 0.0;
    textController.clear();
  }

  Map<String, String> getSuksesData(dynamic args) {
    if (args != null) {
      return {
        'total': currencyFormatter.format(double.parse(args['total'].toString())),
        'label': args['metode'] == 'cash' ? "Tunai / Cash" : args['metode'].toString().toUpperCase(),
        'bayar': currencyFormatter.format(double.parse(args['bayar'].toString())),
        'kembalian': currencyFormatter.format(double.parse(args['kembalian'].toString())),
        'isHistory': 'true',
      };
    } else {
      return {
        'total': currencyFormatter.format(totalPrice),
        'label': paymentMethodLabel,
        'bayar': paymentDisplayValueFormatted,
        'kembalian': kembalianDisplayFormatted,
        'isHistory': 'false',
      };
    }
  }

  void handleSelesaiAction(bool isFromHistory) async {
    if (isFromHistory) {
      Get.back();
    } else {
      await prosesKeApi();
      clearCart();
      Get.offAllNamed('/navbar');
    }
  }

  Future<void> prosesKeApi() async {
    if (cartItems.isNotEmpty) {
      bool success = await ApiService.createTransaction(
        total: totalPrice,
        bayar: selectedPayment.value == "cash" ? inputUang.value : totalPrice,
        kembalian: selectedPayment.value == "cash" ? kembalian : 0.0,
        metode: selectedPayment.value,
        cart: cartItems,
      );

      if (success) {
        if (Get.isRegistered<RiwayatController>()) {
          Get.find<RiwayatController>().fetchHistory();
        }
      } else {
        Get.snackbar(
          "Gagal", 
          "Database gagal menyimpan transaksi",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  // GETTERS
  double get totalPrice => cartItems.fold(0, (sum, item) => sum + ((item.price - item.discount) * item.qty));
  double get subtotal => cartItems.fold(0, (sum, item) => sum + (item.price * item.qty));
  double get kembalian => inputUang.value > totalPrice ? inputUang.value - totalPrice : 0.0;
  double get totalDiscount => cartItems.fold(0, (sum, item) => sum + (item.discount * item.qty));
  int get itemCount => cartItems.length;

  // Logika baru untuk Button
  bool get hasInputUang => inputUang.value > 0; // Cek apakah sudah ketik uang (untuk aktifkan tombol)
  bool get isUangCukup => inputUang.value >= totalPrice; // Cek kecukupan uang (untuk validasi transaksi)

  String get paymentMethodLabel {
    switch (selectedPayment.value) {
      case 'va': return "Virtual Account";
      case 'qris': return "QRIS";
      default: return "Tunai / Cash";
    }
  }

  // Getter dengan format titik
  String get paymentDisplayValueFormatted {
    double value = selectedPayment.value == "cash" ? inputUang.value : totalPrice;
    return currencyFormatter.format(value);
  }

  String get kembalianDisplayFormatted {
    return selectedPayment.value == "cash" ? currencyFormatter.format(kembalian) : "Rp 0";
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}