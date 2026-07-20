import 'dart:convert';

class EscPosEncoder {
  // Karakter Kontrol Standard ESC/POS
  static const int _esc = 0x1B;
  static const int _gs = 0x1D;

  /// Inisialisasi printer ke kondisi default
  List<int> init() => [_esc, 0x40];

  /// Set perataan teks (0: Kiri, 1: Tengah, 2: Kanan)
  List<int> align(int justification) {
    return [_esc, 0x61, justification];
  }

  /// Aktifkan atau nonaktifkan mode Bold
  List<int> setBold(bool isBold) {
    return [_esc, 0x45, isBold ? 1 : 0];
  }

  /// Perintah memotong kertas (Full cut / Partial cut)
  List<int> cutPaper() {
    return [_gs, 0x56, 66, 0];
  }

  /// Membuat baris kosong sebanyak [lines]
  List<int> lineFeed(int lines) {
    return List.filled(lines, 0x0A);
  }

  /// Mengubah String biasa menjadi format Bytes (menggunakan CodePage Latin1/CP437 agar kompatibel teks thermal)
  List<int> textToBytes(String text) {
    return latin1.encode(text);
  }

  /// Mengonversi teks nota terstruktur dari ReceiptBuilder menjadi raw bytes ESC/POS lengkap dengan feed & cut
  List<int> compileReceipt(String receiptText) {
    final List<int> bytes = [];

    bytes.addAll(init());
    bytes.addAll(align(0)); // Default rata kiri
    bytes.addAll(textToBytes(receiptText));
    bytes.addAll(lineFeed(4)); // Spasi potong manual/auto
    bytes.addAll(cutPaper());

    return bytes;
  }
}
