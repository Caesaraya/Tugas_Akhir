import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';
import 'package:tugas_akhir/controller/detail_transaction_controller.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/riwayat_controller.dart';
import 'package:tugas_akhir/api%20service/api_service.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/routes/routes.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CartController extends GetxController {
  final textController = TextEditingController();

  var cartItems = <CartItem>[].obs;
  var selectedPayment = 'cash'.obs;
  var inputUang = 0.0.obs;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

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
      inputUang.value =
          double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }
  }

  void clearCart() {
    cartItems.clear();
    selectedPayment.value = 'cash';
    inputUang.value = 0.0;
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
      await prosesKeApi();
      clearCart();
      Get.offAllNamed('/dashboardMobile');
    }
  }

  void handleSelesaiActionDashboard(bool isFromHistory) async {
    if (isFromHistory) {
      Get.back();
    } else {
      await prosesKeApi();
      clearCart();
      Get.offAllNamed(AppRoutes.kasirboarddesk);
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

  Future<void> generateAndPrintPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          80 * PdfPageFormat.mm,
          double.infinity,
          marginAll: 5,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'TOKO LEZAAA',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              pw.Center(
                child: pw.Text(
                  'Kudus, Jl Dr Lukmono Hadi No.50',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ),

              pw.SizedBox(height: 10),

              pw.Text(
                'Tanggal : ${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 10),
              ),

              pw.Text(
                'Metode : $paymentMethodLabel',
                style: const pw.TextStyle(fontSize: 10),
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
                    pw.Text(item.name, style: const pw.TextStyle(fontSize: 11)),

                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          '${item.qty} x ${currencyFormatter.format(hargaDiskon)}',
                          style: const pw.TextStyle(fontSize: 10),
                        ),

                        pw.Text(
                          currencyFormatter.format(total),
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                      ],
                    ),

                    if (persen > 0)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 2),
                        child: pw.Text(
                          'Diskon ${persen.toStringAsFixed(0)}% (-${currencyFormatter.format(totalDiskon)})',
                          style: pw.TextStyle(
                            fontSize: 8,
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
                  pw.Text('Subtotal'),
                  pw.Text(currencyFormatter.format(subtotal)),
                ],
              ),

              pw.SizedBox(height: 4),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Total Diskon'),
                  pw.Text(currencyFormatter.format(totalDiscount)),
                ],
              ),

              pw.SizedBox(height: 4),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Total',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),

                  pw.Text(
                    currencyFormatter.format(totalPrice),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),

              pw.SizedBox(height: 4),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Bayar'),
                  pw.Text(paymentDisplayValueFormatted),
                ],
              ),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Kembalian'),
                  pw.Text(kembalianDisplayFormatted),
                ],
              ),

              pw.SizedBox(height: 20),

              pw.Center(
                child: pw.Text(
                  'Terima Kasih',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),

              pw.Center(
                child: pw.Text(
                  'Powered by LEZZAAA POS',
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ),
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
    await prosesKeApi();

    clearCart();

    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().fetchProducts();
    }

    final isDesktop = MediaQuery.of(Get.context!).size.width >= 600;

    if (isDesktop) {
      Get.offAllNamed(AppRoutes.kasirboarddesk);
    } else {
      Get.offAllNamed(AppRoutes.dashboardMobile);
    }
  }

  Future<void> printFromDetail(TransactionDetailController ctrl) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          80 * PdfPageFormat.mm,
          double.infinity,
          marginAll: 5,
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'TOKO LEZAAA',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                'Kudus, Jl Dr Lukmono Hadi No.50',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 9),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Nota   : #${ctrl.transactionId}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              'Tanggal: ${ctrl.tanggal}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Text(
              'Metode : ${ctrl.methodLabel}',
              style: const pw.TextStyle(fontSize: 10),
            ),
            pw.Divider(),

            // ✅ Pakai data dari detailController, bukan cartItems
            ...ctrl.items.map((item) {
              final String nama = ctrl.namaProduk(item);
              final int quantity = ctrl.qty(item);
              final double harga = ctrl.hargaSetelahDiskon(item);
              final double total = harga * quantity;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(nama, style: const pw.TextStyle(fontSize: 11)),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        '$quantity x ${currencyFormatter.format(harga)}',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.Text(
                        currencyFormatter.format(total),
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  if (ctrl.hasDiscount(item))
                    pw.Text(
                      'Diskon: ${currencyFormatter.format(ctrl.hargaAsli(item))} → ${currencyFormatter.format(harga)}',
                      style: pw.TextStyle(
                        fontSize: 8,
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
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  ctrl.totalFormatted,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [pw.Text('Bayar'), pw.Text(ctrl.bayarFormatted)],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Kembalian'),
                pw.Text(ctrl.kembalianFormatted),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Center(
              child: pw.Text(
                'Terima Kasih',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Center(
              child: pw.Text(
                'Powered by LEZZAAA POS',
                style: const pw.TextStyle(fontSize: 8),
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
