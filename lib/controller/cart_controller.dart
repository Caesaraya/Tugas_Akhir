import 'dart:async';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/controller/detail_transaction_controller.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tugas_akhir/data/repository/cart_repository.dart';
import 'package:tugas_akhir/data/repository/transaction_repository.dart';
import 'package:tugas_akhir/data/sync/sync_manager.dart';
import 'package:tugas_akhir/data/sync/connectivity_service.dart';

class CartController extends GetxController {
  final textController = TextEditingController();

  var cartItems = <CartItem>[].obs;
  var selectedPayment = 'cash'.obs;
  var inputUang = 0.0.obs;

  // Variabel baru untuk pengaturan ukuran kertas fleksibel (Default: 80mm / false)
  // Nanti Anda bisa buat toggle di UI untuk mengubah ini menjadi true (58mm)
  var isPrint58mm = false.obs;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final CartRepository _cartRepository = CartRepository.instance;
  final TransactionRepository _transactionRepository =
      TransactionRepository.instance;

  @override
  void onInit() {
    super.onInit();
    // Muat cart yang sempat tersimpan (mis. app pernah tertutup paksa
    // di tengah transaksi) supaya kasir tidak kehilangan input.
    _loadPersistedCart();
  }

  Future<void> _loadPersistedCart() async {
    final persisted = await _cartRepository.getCart();
    if (persisted.isNotEmpty) {
      cartItems.assignAll(persisted);
    }
  }

  // Setiap perubahan cart langsung ditulis ke SQLite (fire-and-forget,
  // tidak di-await agar UI tetap responsif) -- ini HANYA persistence,
  // tidak pernah masuk sync_queue (lihat CartRepository).
  void addToCart(Product product) {
    var existingItem = cartItems.firstWhereOrNull(
      (item) => item.productId == product.id,
    );
    if (existingItem != null) {
      existingItem.qty++;
      cartItems.refresh();
      _cartRepository.upsertItem(existingItem);
    } else {
      final newItem = CartItem(
        productId: product.id,
        name: product.name,
        price: product.price,
        discount: product.discount,
        qty: 1,
      );
      cartItems.add(newItem);
      _cartRepository.upsertItem(newItem);
    }
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.productId == productId);
    _cartRepository.removeItem(productId);
  }

  void increaseQty(int productId) {
    var item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null) {
      item.qty++;
      cartItems.refresh();
      _cartRepository.upsertItem(item);
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
        _cartRepository.upsertItem(item);
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
    _cartRepository.clear();
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
      // Refresh dashboard agar stok langsung update
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

  // PERUBAHAN UTAMA offline-first: checkout SEKARANG menulis ke SQLite lokal
  // dulu (lewat TransactionRepository.checkout()) -- ini SELALU berhasil
  // walau tidak ada internet sama sekali, karena tidak menyentuh network.
  // Pengiriman ke backend didaftarkan ke sync_queue dan diproses oleh
  // SyncManager kapan pun koneksi tersedia (lihat bootstrap.dart).
  //
  // Karena itu snackbar "Gagal" yang dulu muncul saat request API gagal
  // TIDAK RELEVAN lagi di titik ini -- kegagalan network bukan lagi
  // kegagalan transaksi bagi kasir, cukup tertunda sinkronnya.
  Future<void> prosesKeApi() async {
    if (cartItems.isEmpty) return;

    await _transactionRepository.checkout(
      cart: cartItems,
      total: totalPrice,
      bayar: selectedPayment.value == "cash" ? inputUang.value : totalPrice,
      kembalian: selectedPayment.value == "cash" ? kembalian : 0.0,
      metode: selectedPayment.value,
    );

    // Riwayat sekarang membaca dari TransactionRepository (SQLite), jadi
    // langsung tampil walau baris ini belum sempat ke server.
    if (Get.isRegistered<RiwayatController>()) {
      Get.find<RiwayatController>().fetchHistory();
    }

    // Coba sync sekarang juga kalau kebetulan online -- best effort saja,
    // kegagalan di sini tidak memengaruhi transaksi yang sudah tersimpan
    // lokal. Jika offline, ConnectivityService yang akan memicu sync
    // otomatis begitu koneksi kembali.
    final online = await ConnectivityService.instance.isOnline;
    if (online) {
      unawaited(SyncManager.instance.runSync());
    }
  }

  Future<void> generateAndPrintPdf() async {
    final isDesktop = MediaQuery.of(Get.context!).size.width >= 600;
    final pdf = pw.Document();

    // Variabel dinamis berdasarkan ukuran kertas (58mm atau 80mm)
    final bool is58mm = isPrint58mm.value;
    final double printerWidth = is58mm ? 58.0 : 80.0;
    final double marginPdf = is58mm ? 2.0 : 5.0;

    // Penyesuaian ukuran font otomatis
    final double titleSize = is58mm ? 13.0 : 16.0;
    final double addressSize = is58mm ? 7.0 : 9.0;
    final double normalSize = is58mm ? 8.0 : 10.0;
    final double itemNameSize = is58mm ? 9.0 : 11.0;
    final double smallSize = is58mm ? 6.5 : 8.0;

    pdf.addPage(
      pw.Page(
        pageFormat: isDesktop
            ? PdfPageFormat.a4
            : PdfPageFormat(
                printerWidth * PdfPageFormat.mm,
                double.infinity,
                marginAll: marginPdf,
              ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'TOKO LEZAAA',
                  style: pw.TextStyle(
                    fontSize: titleSize,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.Center(
                child: pw.Text(
                  'Kudus, Jl Dr Lukmono Hadi No.50',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: addressSize),
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text(
                'Tanggal : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
                style: pw.TextStyle(fontSize: normalSize),
              ),

              pw.Text(
                'Metode : $paymentMethodLabel',
                style: pw.TextStyle(fontSize: normalSize),
              ),

              pw.Divider(),

              ...cartItems.map((item) {
                final double hargaAsli = item.price.toDouble();
                final double persen = (item.discount ?? 0).toDouble();
                final double hargaDiskon =
                    (hargaAsli - (hargaAsli * persen / 100)).roundToDouble();
                final total = hargaDiskon * item.qty;
                final totalAsli = hargaAsli * item.qty;
                final totalDiskon = totalAsli - total;

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      item.name,
                      style: pw.TextStyle(fontSize: itemNameSize),
                    ),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '${item.qty} x ${currencyFormatter.format(hargaDiskon)}',
                          style: pw.TextStyle(fontSize: normalSize),
                        ),

                        pw.Text(
                          currencyFormatter.format(total),
                          style: pw.TextStyle(fontSize: normalSize),
                        ),
                      ],
                    ),

                    if (persen > 0)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 2),
                        child: pw.Text(
                          'Diskon ${persen.toStringAsFixed(0)}% (-${currencyFormatter.format(totalDiskon)})',
                          style: pw.TextStyle(
                            fontSize: smallSize,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ),

                    pw.SizedBox(height: 6),
                  ],
                );
              }),

              pw.Divider(),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Subtotal',
                    style: pw.TextStyle(fontSize: normalSize),
                  ),
                  pw.Text(
                    currencyFormatter.format(subtotal),
                    style: pw.TextStyle(fontSize: normalSize),
                  ),
                ],
              ),

              pw.SizedBox(height: 4),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total Diskon',
                    style: pw.TextStyle(fontSize: normalSize),
                  ),
                  pw.Text(
                    currencyFormatter.format(totalDiscount),
                    style: pw.TextStyle(fontSize: normalSize),
                  ),
                ],
              ),

              pw.SizedBox(height: 4),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: normalSize,
                    ),
                  ),

                  pw.Text(
                    currencyFormatter.format(totalPrice),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: normalSize,
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 4),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Bayar', style: pw.TextStyle(fontSize: normalSize)),
                  pw.Text(
                    paymentDisplayValueFormatted,
                    style: pw.TextStyle(fontSize: normalSize),
                  ),
                ],
              ),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Kembalian',
                    style: pw.TextStyle(fontSize: normalSize),
                  ),
                  pw.Text(
                    kembalianDisplayFormatted,
                    style: pw.TextStyle(fontSize: normalSize),
                  ),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Center(
                child: pw.Text(
                  'Terima Kasih',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: normalSize,
                  ),
                ),
              ),

              pw.Center(
                child: pw.Text(
                  'Powered by LEZZAAA POS',
                  style: pw.TextStyle(fontSize: smallSize),
                ),
              ),
            ],
          );
        },
      ),
    );

    // Proses ke API DULU, supaya data aman kalau print dibatalkan
    await prosesKeApi();

    // Jalankan fitur print
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());

    // Bersihkan keranjang & kembali ke dashboard
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

  Future<void> printFromDetail(TransactionDetailController ctrl) async {
    final pdf = pw.Document();

    // Variabel dinamis berdasarkan ukuran kertas (58mm atau 80mm)
    final bool is58mm = isPrint58mm.value;
    final double printerWidth = is58mm ? 58.0 : 80.0;
    final double marginPdf = is58mm ? 2.0 : 5.0;

    // Penyesuaian ukuran font otomatis
    final double titleSize = is58mm ? 13.0 : 16.0;
    final double addressSize = is58mm ? 7.0 : 9.0;
    final double normalSize = is58mm ? 8.0 : 10.0;
    final double itemNameSize = is58mm ? 9.0 : 11.0;
    final double smallSize = is58mm ? 6.5 : 8.0;

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          printerWidth * PdfPageFormat.mm,
          double.infinity,
          marginAll: marginPdf,
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'TOKO LEZAAA',
                style: pw.TextStyle(
                  fontSize: titleSize,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                'Kudus, Jl Dr Lukmono Hadi No.50',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: addressSize),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Nota   : #${ctrl.transactionId}',
              style: pw.TextStyle(fontSize: normalSize),
            ),
            pw.Text(
              'Tanggal: ${ctrl.tanggal}',
              style: pw.TextStyle(fontSize: normalSize),
            ),
            pw.Text(
              'Metode : ${ctrl.methodLabel}',
              style: pw.TextStyle(fontSize: normalSize),
            ),
            pw.Divider(),
            ...ctrl.items.map((item) {
              final String nama = ctrl.namaProduk(item);
              final int quantity = ctrl.qty(item);
              final double harga = ctrl.hargaSetelahDiskon(item);
              final double total = harga * quantity;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(nama, style: pw.TextStyle(fontSize: itemNameSize)),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        '$quantity x ${currencyFormatter.format(harga)}',
                        style: pw.TextStyle(fontSize: normalSize),
                      ),
                      pw.Text(
                        currencyFormatter.format(total),
                        style: pw.TextStyle(fontSize: normalSize),
                      ),
                    ],
                  ),
                  if (ctrl.hasDiscount(item))
                    pw.Text(
                      'Diskon: ${currencyFormatter.format(ctrl.hargaAsli(item))} → ${currencyFormatter.format(harga)}',
                      style: pw.TextStyle(
                        fontSize: smallSize,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  pw.SizedBox(height: 6),
                ],
              );
            }),

            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Total',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: normalSize,
                  ),
                ),
                pw.Text(
                  ctrl.totalFormatted,
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: normalSize,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Bayar', style: pw.TextStyle(fontSize: normalSize)),
                pw.Text(
                  ctrl.bayarFormatted,
                  style: pw.TextStyle(fontSize: normalSize),
                ),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Kembalian', style: pw.TextStyle(fontSize: normalSize)),
                pw.Text(
                  ctrl.kembalianFormatted,
                  style: pw.TextStyle(fontSize: normalSize),
                ),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                'Terima Kasih',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: normalSize,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                'Powered by LEZZAAA POS',
                style: pw.TextStyle(fontSize: smallSize),
              ),
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
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
