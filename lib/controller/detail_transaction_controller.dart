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
     if (data['items'] != null && (data['items'] as List).isNotEmpty) {
    print('DEBUG item keys: ${data['items'][0].keys.toList()}');
    print('DEBUG item data: ${data['items'][0]}');
  }
  }
 

  String get transactionId =>
      data['id']?.toString() ?? data['id_transaksi']?.toString() ?? '-';
 
  String get tanggal => data['tanggal']?.toString() ?? '-';
 
  String get methodLabel {
    final raw = data['metode_pembayaran']?.toString() ?? '-';
    switch (raw) {
      case 'cash':
        return 'Tunai / Cash';
      case 'qris':
        return 'QRIS';
      case 'va':
        return 'Virtual Account';
      default:
        return raw;
    }
  }
 

  List<Map<String, dynamic>> get items =>
      ((data['items'] as List<dynamic>?) ?? [])
          .map((e) => e as Map<String, dynamic>)
          .toList();
 

  String namaProduk(Map<String, dynamic> item) =>
    item['nama_produk']?.toString() ??
    item['name']?.toString() ??
    item['produk']?.toString() ??
    item['product_name']?.toString() ??
    item['nama']?.toString() ??
    item['title']?.toString() ??
    'Produk';
 
  double hargaAsli(Map<String, dynamic> item) =>
      double.tryParse(item['price']?.toString() ?? '0') ?? 0;
 
  double nilaiDiskon(Map<String, dynamic> item) =>
      double.tryParse(item['discount']?.toString() ?? '0') ?? 0;
 

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
 
  int qty(Map<String, dynamic> item) =>
      (item['qty'] ?? item['quantity'] ?? 0) as int;
 
  bool hasDiscount(Map<String, dynamic> item) => nilaiDiskon(item) > 0;
 

  String get totalFormatted =>
      currencyFormatter.format(_parseValue(data['total_harga']));
 
  String get bayarFormatted =>
      currencyFormatter.format(_parseValue(data['jumlah_bayar']));
 
  String get kembalianFormatted =>
      currencyFormatter.format(_parseValue(data['kembalian']));
 
  double _parseValue(dynamic value) =>
      double.tryParse(value?.toString() ?? '0') ?? 0;
}