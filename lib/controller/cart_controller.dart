import 'dart:async';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/controller/detail_transaction_controller.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:tugas_akhir/data/repository/cart_repository.dart';
import 'package:tugas_akhir/data/repository/transaction_repository.dart';
import 'package:tugas_akhir/data/sync/sync_manager.dart';
import 'package:tugas_akhir/data/sync/connectivity_service.dart';

// Import komponen arsitektur printer baru
import 'package:tugas_akhir/services/printer/receipt_builder.dart';
import 'package:tugas_akhir/services/printer/escpos_encoder.dart';
import 'package:tugas_akhir/services/printer/printer_service.dart';
import 'package:tugas_akhir/services/printer/windows_printer_service.dart';
import 'package:tugas_akhir/services/printer/bluetooth_printer_service.dart';

class CartController extends GetxController {
  final textController = TextEditingController();

  var cartItems = <CartItem>[].obs;
  var selectedPayment = 'cash'.obs;
  var inputUang = 0.0.obs;

  var isPrint58mm = false.obs;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final CartRepository cartRepository = CartRepository.instance;
  final TransactionRepository transactionRepository =
      TransactionRepository.instance;

  // Injeksi komponen Printer Multi-Layer baru
  final ReceiptBuilder _receiptBuilder = ReceiptBuilder();
  final EscPosEncoder _escPosEncoder = EscPosEncoder();
  late final PrinterService _printerService;

  @override
  void onInit() {
    super.onInit();
    _initPrinterService();
    _loadPersistedCart();
  }

  /// Memilih service printer secara dinamis berdasarkan platform device OS
  void _initPrinterService() {
    if (GetPlatform.isWindows) {
      _printerService = WindowsPrinterService(
        targetPrinterName: "Generic / Text Only",
      );
    } else {
      // Sesuai kebutuhan Android target arsitektur Bluetooth ESC/POS
      _printerService = BluetoothPrinterService(targetPrinterName: "RPP02N");
    }
  }

  Future<void> _loadPersistedCart() async {
    final persisted = await cartRepository.getCart();
    if (persisted.isNotEmpty) {
      cartItems.assignAll(persisted);
    }
  }

  bool addToCart(Product product) {
    var existingItem = cartItems.firstWhereOrNull(
      (item) => item.productId == product.id,
    );
    if (existingItem != null) {
      if (existingItem.qty >= product.stock) {
        Get.snackbar(
          "Stok Habis",
          "Stok ${product.name} hanya ${product.stock} ${product.satuan}",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(milliseconds: 1500),
          margin: const EdgeInsets.all(10),
        );
        return false;
      }
      existingItem.qty++;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          productId: product.id,
          name: product.name,
          price: product.price,
          discount: product.discount ?? 0,
          stock: product.stock,
          qty: 1,
        ),
      );
    }
    return true;
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.productId == productId);
    cartRepository.removeItem(productId);
  }

  void increaseQty(int productId) {
    var item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null) {
      if (item.qty >= item.stock) {
        return;
      }
      item.qty++;
      cartItems.refresh();
      cartRepository.upsertItem(item);
    }
  }

  void setQty(Product product, int qty) {
    final maxQty = product.stock;
    final finalQty = qty > maxQty ? maxQty : qty;

    if (finalQty <= 0) {
      removeFromCart(product.id);
      return;
    }
    var existing = cartItems.firstWhereOrNull(
      (item) => item.productId == product.id,
    );
    if (existing != null) {
      existing.qty = finalQty;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          productId: product.id,
          name: product.name,
          price: product.price,
          discount: product.discount ?? 0,
          stock: product.stock,
          qty: finalQty,
        ),
      );
    }

    if (qty > maxQty) {
      Get.snackbar(
        "Stok ",
        "Maksimal ${product.name} hanya $maxQty ${product.satuan}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 1500),
        margin: const EdgeInsets.all(10),
      );
    }
  }

  void decreaseQty(int productId) {
    var item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null) {
      if (item.qty > 1) {
        item.qty--;
        cartItems.refresh();
        cartRepository.upsertItem(item);
      } else {
        removeFromCart(productId);
      }
    }
  }

  void setInputUang(String value) {
    if (value.isEmpty) {
      inputUang.value = 0;
    } else {
      inputUang.value =
          double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }
  }

  void clearCart() {
    cartItems.clear();
    selectedPayment.value = 'cash';
    inputUang.value = 0.0;
    cartRepository.clear();
  }

  Map<String, String> getSuksesData(dynamic args) {
    if (args != null) {
      return {
        'total': currencyFormatter.format(
          double.parse(args['total'].toString()),
        ),
        'label': args['metode'] == 'cash'
            ? "Tunai / Cash"
            : args['metode'].toString().toUpperCase(),
        'bayar': currencyFormatter.format(
          double.parse(args['bayar'].toString()),
        ),
        'kembalian': currencyFormatter.format(
          double.parse(args['kembalian'].toString()),
        ),
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

  void handleSelesaiActionMobile(bool isFromHistory) async {
    if (isFromHistory) {
      Get.back();
    } else {
      try {
        await prosesKeApi();
      } catch (e) {
        debugPrint('prosesKeApi mobile error: $e');
      }
      clearCart();
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().fetchProducts();
      }
      Get.offAllNamed(AppRoutes.dashboardMobile);
    }
  }

  void handleSelesaiActionDashboard(bool isFromHistory) async {
    if (isFromHistory) {
      Get.back();
    } else {
      try {
        await prosesKeApi();
      } catch (e) {
        debugPrint('prosesKeApi desktop error: $e');
      }
      clearCart();
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().fetchProducts();
      }
      Get.offAllNamed(AppRoutes.kasirboarddesk);
    }
  }

  Future<void> prosesKeApi() async {
    if (cartItems.isEmpty) return;

    await transactionRepository.checkout(
      cart: cartItems,
      total: totalPrice,
      bayar: selectedPayment.value == "cash" ? inputUang.value : totalPrice,
      kembalian: selectedPayment.value == "cash" ? kembalian : 0.0,
      metode: selectedPayment.value,
    );

    if (Get.isRegistered<RiwayatController>()) {
      Get.find<RiwayatController>().fetchHistory();
    }

    final online = await ConnectivityService.instance.isOnline;
    if (online) {
      unawaited(SyncManager.instance.runSync());
    }
  }

  // ✅ 1. Mengganti buildNotaPdf() menjadi buildReceiptText() sesuai arsitektur target
  String buildReceiptText() {
    final List<Map<String, dynamic>> structuredItems = cartItems.map((item) {
      final double hargaAsli = item.price.toDouble();
      final double persen = (item.discount ?? 0).toDouble();
      final double hargaDiskon = (hargaAsli - (hargaAsli * persen / 100))
          .roundToDouble();
      final total = hargaDiskon * item.qty;
      final totalAsli = hargaAsli * item.qty;
      final totalDiskon = totalAsli - total;

      String? discountInfo;
      if (persen > 0) {
        discountInfo =
            'Diskon ${persen.toStringAsFixed(0)}% (-${currencyFormatter.format(totalDiskon)})';
      }

      return {
        'name': item.name,
        'qty': item.qty,
        'price': hargaDiskon,
        'total': total,
        'discount_info': discountInfo,
      };
    }).toList();

    return _receiptBuilder.buildText(
      methodLabel: paymentMethodLabel,
      items: structuredItems,
      subtotal: subtotal,
      totalDiscount: totalDiscount,
      totalPrice: totalPrice,
      bayar: selectedPayment.value == "cash" ? inputUang.value : totalPrice,
      kembalian: selectedPayment.value == "cash" ? kembalian : 0.0,
      is58mm: isPrint58mm.value,
    );
  }

  // ✅ 2. Mengubah printNotaSaja() agar memanggil layer Encoder dan PrinterService lintas platform
  Future<void> printNotaSaja() async {
    final String text = buildReceiptText();
    final List<int> bytes = _escPosEncoder.compileReceipt(text);
    await _printerService.sendBytes(bytes);
  }

  // ✅ 3. Mengganti generateAndPrintPdf() menjadi generateAndPrintReceipt() dengan mempertahankan business logic
  Future<void> generateAndPrintReceipt() async {
    final isDesktop = MediaQuery.of(Get.context!).size.width >= 600;

    // Alur Cetak Terpisah
    final String text = buildReceiptText();
    final List<int> bytes = _escPosEncoder.compileReceipt(text);
    await _printerService.sendBytes(bytes);

    // Alur penyimpanan transaksi data offline & sync api tetap aman terlindungi
    await prosesKeApi();
    clearCart();

    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().fetchProducts();
    }

    if (isDesktop) {
      Get.offAllNamed(AppRoutes.kasirboarddesk);
    } else {
      Get.offAllNamed(AppRoutes.dashboardMobile);
    }
  }

  // ✅ 4. Mengubah printFromDetail() menggunakan ReceiptBuilder baru yang aman dari bad layout wrapping
  Future<void> printFromDetail(TransactionDetailController ctrl) async {
    final List<Map<String, dynamic>> structuredItems = ctrl.items.map((item) {
      final String nama = ctrl.namaProduk(item);
      final int quantity = ctrl.qty(item);
      final double harga = ctrl.hargaSetelahDiskon(item);
      final double total = harga * quantity;

      String? discountInfo;
      if (ctrl.hasDiscount(item)) {
        discountInfo =
            'Diskon: ${currencyFormatter.format(ctrl.hargaAsli(item))} -> ${currencyFormatter.format(harga)}';
      }

      return {
        'name': nama,
        'qty': quantity,
        'price': harga,
        'total': total,
        'discount_info': discountInfo,
      };
    }).toList();

    double parseRaw(dynamic val) =>
        double.tryParse(val?.toString() ?? '0') ?? 0;

    final String text = _receiptBuilder.buildText(
      notaId: ctrl.transactionId,
      methodLabel: ctrl.methodLabel,
      items: structuredItems,
      subtotal: parseRaw(ctrl.data['total_harga']),
      totalDiscount:
          0.0, // Dihitung di internal builder dari subtotal dan totalPrice jika ada perbedaan
      totalPrice: parseRaw(ctrl.data['total_harga']),
      bayar: parseRaw(ctrl.data['jumlah_bayar']),
      kembalian: parseRaw(ctrl.data['kembalian']),
      is58mm: isPrint58mm.value,
      customDate: DateTime.tryParse(ctrl.tanggal),
    );

    final List<int> bytes = _escPosEncoder.compileReceipt(text);
    await _printerService.sendBytes(bytes);
  }

  double get totalPrice {
    return cartItems.fold(0, (sum, item) {
      double hargaAsli = item.price.toDouble();
      double persenDiskon = (item.discount ?? 0).toDouble();
      double hargaSetelahDiskon =
          (hargaAsli - (hargaAsli * (persenDiskon / 100))).roundToDouble();
      return sum + (hargaSetelahDiskon * item.qty);
    });
  }

  double get subtotal =>
      cartItems.fold(0, (sum, item) => sum + (item.price * item.qty));

  double get totalDiscount => subtotal - totalPrice;

  double get kembalian =>
      inputUang.value > totalPrice ? inputUang.value - totalPrice : 0.0;

  int get itemCount => cartItems.length;

  bool get hasInputUang => inputUang.value > 0;
  bool get isUangCukup => inputUang.value >= totalPrice;

  String get paymentMethodLabel {
    switch (selectedPayment.value) {
      case 'va':
        return "Virtual Account";
      case 'qris':
        return "QRIS";
      default:
        return "Tunai / Cash";
    }
  }

  String get paymentDisplayValueFormatted {
    double value = selectedPayment.value == "cash"
        ? inputUang.value
        : totalPrice;
    return currencyFormatter.format(value);
  }

  String get kembalianDisplayFormatted {
    return selectedPayment.value == "cash"
        ? currencyFormatter.format(kembalian)
        : "Rp 0";
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }
}
