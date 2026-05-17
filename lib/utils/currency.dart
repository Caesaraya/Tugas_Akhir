import 'package:intl/intl.dart';

final NumberFormat _rupiahFormatter = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

String formatRupiah(num value) => _rupiahFormatter.format(value);

int parseRupiah(String text) {
  final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
  return int.tryParse(clean) ?? 0;
}
