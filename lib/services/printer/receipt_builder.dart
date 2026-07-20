import 'package:intl/intl.dart';

class ReceiptBuilder {
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  String buildText({
    required String methodLabel,
    required List<Map<String, dynamic>> items,
    required double subtotal,
    required double totalDiscount,
    required double totalPrice,
    required double bayar,
    required double kembalian,
    required bool is58mm,
    String? notaId,
    DateTime? customDate,
  }) {
    final int width = is58mm ? 30 : 32;
    final buffer = StringBuffer();

    // Helper: Tengahkan Teks secara presisi
    String center(String text) {
      if (text.length >= width) return text.substring(0, width);
      int spaces = (width - text.length) ~/ 2;
      return ' ' * spaces + text;
    }

    // Helper: Buat baris Kolom Kiri dan Kanan secara presisi dengan pembungkusan teks (wrapping)
    String makeRow(String left, String right) {
      int availableSpace = width - left.length - right.length;

      if (availableSpace < 1) {
        // Jika teks terlalu panjang, potong text kiri dan berikan ruang space minimal 1
        int maxLeftLength = width - right.length - 1;
        if (maxLeftLength > 0) {
          left = left.substring(0, maxLeftLength);
          availableSpace = width - left.length - right.length;
        } else {
          // Kasus ekstrim jika harga kanan sangat panjang, pisah baris
          return left + '\n' + ' ' * (width - right.length) + right;
        }
      }
      return left + (' ' * availableSpace) + right;
    }

    // Helper: Memotong nama produk panjang menjadi multi-line secara rapi
    List<String> wrapText(String text, int maxLength) {
      List<String> lines = [];
      while (text.length > maxLength) {
        lines.add(text.substring(0, maxLength));
        text = text.substring(maxLength);
      }
      if (text.isNotEmpty) lines.add(text);
      return lines;
    }

    final String divider = '-' * width;

    // --- HEADER ---
    buffer.writeln(center('TOKO LEZAAA'));
    buffer.writeln(center('Kudus, Jl Dr Lukmono Hadi No.50'));
    buffer.writeln(divider);

    // --- META DATA TRANSAKSI ---
    if (notaId != null) {
      buffer.writeln(makeRow('Nota:', '#$notaId'));
    }
    final dateStr = DateFormat(
      'dd-MM-yyyy HH:mm',
    ).format(customDate ?? DateTime.now());
    buffer.writeln(makeRow('Tanggal:', dateStr));
    buffer.writeln(makeRow('Metode:', methodLabel));
    buffer.writeln(divider);

    // --- DAFTAR ITEM ---
    for (var item in items) {
      String name = item['name'] ?? 'Produk';
      int qty = item['qty'] ?? 0;
      double harga = item['price'] ?? 0.0;
      double totalItem = item['total'] ?? (harga * qty);

      // Proteksi Wrapping Nama Produk Panjang agar tidak merusak kolom nominal rupiah
      List<String> wrappedName = wrapText(name, width);
      for (var nameLine in wrappedName) {
        buffer.writeln(nameLine);
      }

      String qtyPriceStr = '  $qty x ${currencyFormatter.format(harga)}';
      String totalItemStr = currencyFormatter.format(totalItem);
      buffer.writeln(makeRow(qtyPriceStr, totalItemStr));

      if (item['discount_info'] != null) {
        buffer.writeln('  ${item['discount_info']}');
      }
    }

    buffer.writeln(divider);

    // --- RINCIAN PEMBAYARAN & FINANSIAL ---
    if (totalDiscount > 0) {
      buffer.writeln(makeRow('Subtotal', currencyFormatter.format(subtotal)));
      buffer.writeln(
        makeRow('Diskon', '-${currencyFormatter.format(totalDiscount)}'),
      );
      buffer.writeln(divider);
    }

    buffer.writeln(makeRow('TOTAL', currencyFormatter.format(totalPrice)));
    buffer.writeln(makeRow('Bayar', currencyFormatter.format(bayar)));
    buffer.writeln(makeRow('Kembalian', currencyFormatter.format(kembalian)));
    buffer.writeln(divider);

    // --- FOOTER ---
    buffer.writeln(center('Terima Kasih'));
    buffer.writeln(center('Powered by'));
    buffer.writeln(center('Rumah Lezaa POS'));

    return buffer.toString();
  }
}
