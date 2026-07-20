abstract interface class PrinterService {
  /// Nama atau identifier unik dari printer target
  String get targetPrinterName;

  /// Method untuk mengirim data raw bytes ESC/POS ke printer device
  Future<bool> sendBytes(List<int> bytes);
}
