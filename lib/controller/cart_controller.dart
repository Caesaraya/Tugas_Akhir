import 'package:get/get.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';

class CartController extends GetxController {
  final textController = TextEditingController();

  var cartItems = <CartItem>[].obs;
  var selectedPayment = 'cash'.obs;
  var inputUang = 0.0.obs;

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
      inputUang.value = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }
  }

  void clearCart() {
    cartItems.clear();
    selectedPayment.value = 'cash';
    inputUang.value = 0.0;
  }

  // ==========================================
  // LOGIKA HALAMAN SUKSES (PINDAHAN DARI UI)
  // ==========================================

  /// Fungsi untuk menyiapkan data yang akan ditampilkan di UI Sukses
  /// Menangani data dari transaksi baru maupun dari Riwayat (arguments)
  Map<String, String> getSuksesData(dynamic args) {
    if (args != null) {
      // Jika data berasal dari Riwayat (Arguments)
      return {
        'total': "Rp ${double.parse(args['total'].toString()).toInt()}",
        'label': args['metode'] == 'cash' ? "Tunai / Cash" : args['metode'].toString().toUpperCase(),
        'bayar': "Rp ${double.parse(args['bayar'].toString()).toInt()}",
        'kembalian': "Rp ${double.parse(args['kembalian'].toString()).toInt()}",
        'isHistory': 'true',
      };
    } else {
      // Jika data berasal dari transaksi yang baru saja selesai
      return {
        'total': "Rp ${totalPrice.toInt()}",
        'label': paymentMethodLabel,
        'bayar': paymentDisplayValue,
        'kembalian': kembalianDisplay,
        'isHistory': 'false',
      };
    }
  }

  /// Fungsi yang dijalankan saat tombol "Selesai" diklik
  void handleSelesaiAction(bool isFromHistory) async {
    if (isFromHistory) {
      Get.back(); // Hanya kembali jika cuma melihat riwayat
    } else {
      await prosesKeApi(); // Simpan ke database
      clearCart();        // Bersihkan keranjang
      Get.offAllNamed('/navbar'); // Kembali ke home (sesuaikan route namamu)
    }
  }

  Future<void> prosesKeApi() async {
    if (cartItems.isNotEmpty) {
      bool success = await ApiService.createTransaction(
        total: totalPrice,
        bayar: inputUang.value,
        kembalian: kembalian,
        metode: selectedPayment.value,
        cart: cartItems,
      );

      if (success) {
        if (Get.isRegistered<RiwayatController>()) {
          Get.find<RiwayatController>().fetchHistory();
        }
        print("Berhasil simpan ke Database!");
      } else {
        Get.snackbar("Gagal", "Database gagal menyimpan transaksi");
      }
    }
  }

  // ==========================================
  // GETTERS
  // ==========================================

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + ((item.price - item.discount) * item.qty));
  double get subtotal => cartItems.fold(0, (sum, item) => sum + (item.price * item.qty));
  double get kembalian => inputUang.value > totalPrice ? inputUang.value - totalPrice : 0.0;
  bool get isUangCukup => inputUang.value >= totalPrice && totalPrice > 0;
  double get totalDiscount => cartItems.fold(0, (sum, item) => sum + (item.discount * item.qty));
  int get itemCount => cartItems.length;

  String get paymentMethodLabel {
    switch (selectedPayment.value) {
      case 'va': return "Virtual Account";
      case 'qris': return "QRIS";
      default: return "Tunai / Cash";
    }
  }

  String get paymentDisplayValue {
    double value = selectedPayment.value == "cash" ? inputUang.value : totalPrice;
    return "Rp ${value.toInt()}";
  }

  String get kembalianDisplay => selectedPayment.value == "cash" ? "Rp ${kembalian.toInt()}" : "Rp 0";

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}