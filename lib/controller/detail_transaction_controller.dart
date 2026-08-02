// lib/controller/detail_transaction_controller.dart

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransactionDetailController extends GetxController {
  late final Map<String, dynamic> data;

  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  void onInit() {
    super.onInit();
    data = Get.arguments as Map<String, dynamic>? ?? {};
  }

  String get transactionId =>
      data['id']?.toString() ??
      data['local_id']?.toString() ??
      data['id_transaksi']?.toString() ??
      '-';

  String get tanggal => data['tanggal']?.toString() ?? '-';

  String get methodLabel {
    final raw = data['metode_pembayaran']?.toString().toLowerCase() ?? '-';
    switch (raw) {
      case 'cash':
        return 'Tunai / Cash';
      case 'qris':
        return 'QRIS';
      case 'va':
        return 'Virtual Account';
      default:
        return data['metode_pembayaran']?.toString() ?? '-';
    }
  }

  List<Map<String, dynamic>> get items {
    final rawItems = data['items'];
    if (rawItems is List) {
      return rawItems.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  String namaProduk(Map<String, dynamic> item) =>
      item['nama_produk']?.toString() ??
      item['name']?.toString() ??
      item['produk']?.toString() ??
      item['product_name']?.toString() ??
      item['nama']?.toString() ??
      item['title']?.toString() ??
      'Produk';

  double hargaAsli(Map<String, dynamic> item) =>
      double.tryParse(item['price']?.toString() ?? '0') ?? 0.0;

  double nilaiDiskon(Map<String, dynamic> item) =>
      double.tryParse(item['discount']?.toString() ?? '0') ?? 0.0;

  double hargaSetelahDiskon(Map<String, dynamic> item) {
    final double asli = hargaAsli(item);
    final double diskon = nilaiDiskon(item);

    if (diskon > 0 && diskon <= 100) {
      return asli - (asli * diskon / 100);
    } else if (diskon > 100) {
      return asli - diskon;
    }
    return asli;
  }

  int qty(Map<String, dynamic> item) {
    final val = item['qty'] ?? item['quantity'] ?? 0;
    if (val is int) return val;
    return int.tryParse(val.toString()) ?? 0;
  }

  bool hasDiscount(Map<String, dynamic> item) => nilaiDiskon(item) > 0;

  double get totalHarga =>
      double.tryParse(data['total_harga']?.toString() ?? '0') ?? 0.0;

  double get jumlahBayar =>
      double.tryParse(data['jumlah_bayar']?.toString() ?? '0') ?? 0.0;

  double get kembalian =>
      double.tryParse(data['kembalian']?.toString() ?? '0') ?? 0.0;

  String get totalFormatted => currencyFormatter.format(totalHarga);
  String get bayarFormatted => currencyFormatter.format(jumlahBayar);
  String get kembalianFormatted => currencyFormatter.format(kembalian);
}
