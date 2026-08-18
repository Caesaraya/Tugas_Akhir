import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:win32/win32.dart';
import 'printer_service.dart';

// Printer status flags
const int PRINTER_STATUS_OFFLINE = 0x00000040;
const int PRINTER_STATUS_ERROR = 0x00000002;
const int PRINTER_STATUS_PAUSED = 0x00000001;

class WindowsPrinterService implements PrinterService {
  @override
  final String targetPrinterName;

  WindowsPrinterService({this.targetPrinterName = "Generic / Text Only"});

  /// Helper method untuk memeriksa status printer lokal
  Future<Map<String, dynamic>> _checkPrinterStatus() async {
    final pPrinterName = targetPrinterName.toNativeUtf16();
    final phPrinter = calloc<HANDLE>();

    try {
      // Buka printer untuk mendapatkan handle
      final result = OpenPrinter(pPrinterName, phPrinter, nullptr);
      if (result == 0) {
        return {
          'exists': false,
          'online': false,
          'error': 'Printer tidak ditemukan',
        };
      }

      final hPrinter = phPrinter.value;

      // Dapatkan ukuran buffer yang dibutuhkan
      final pcbNeeded = calloc<DWORD>();
      GetPrinter(hPrinter, 2, nullptr, 0, pcbNeeded);
      final cbBuf = pcbNeeded.value;

      if (cbBuf == 0) {
        ClosePrinter(hPrinter);
        return {
          'exists': true,
          'online': false,
          'error': 'Tidak dapat membaca status printer',
        };
      }

      // Alokasi buffer untuk PRINTER_INFO_2
      final pPrinterInfo = calloc<Uint8>(cbBuf);
      final result2 = GetPrinter(hPrinter, 2, pPrinterInfo, cbBuf, pcbNeeded);

      ClosePrinter(hPrinter);

      if (result2 == 0) {
        calloc.free(pPrinterInfo);
        calloc.free(pcbNeeded);
        return {
          'exists': true,
          'online': false,
          'error': 'Tidak dapat membaca status printer',
        };
      }

      // Cast buffer ke PRINTER_INFO_2 structure
      // PRINTER_INFO_2 memiliki Status field di offset tertentu
      // Untuk simplicity, kita baca status dari offset
      final printerInfoPtr = pPrinterInfo.cast<Uint32>();

      // Status field biasanya di offset 11 (0-indexed) dalam PRINTER_INFO_2 structure
      // Kita baca 4 bytes untuk DWORD status
      int status = 0;
      try {
        // Offset estimasi untuk status field dalam PRINTER_INFO_2
        final statusPtr = pPrinterInfo.elementAt(
          44,
        ); // 44 bytes adalah offset approximate
        status = statusPtr.cast<Uint32>().value;
      } catch (e) {
        // Jika gagal parse, anggap printer berstatus tidak diketahui
        status = 0;
      }

      calloc.free(pPrinterInfo);
      calloc.free(pcbNeeded);

      // Check status flags
      bool isOffline = (status & PRINTER_STATUS_OFFLINE) != 0;
      bool hasError = (status & PRINTER_STATUS_ERROR) != 0;
      bool isPaused = (status & PRINTER_STATUS_PAUSED) != 0;

      return {
        'exists': true,
        'online': !isOffline && !hasError,
        'offline': isOffline,
        'error': hasError,
        'paused': isPaused,
        'statusCode': status,
      };
    } catch (e) {
      print('❌ [WindowsPrinterService] Error checking printer status: $e');
      return {'exists': false, 'online': false, 'error': 'Exception: $e'};
    } finally {
      calloc.free(pPrinterName);
      calloc.free(phPrinter);
    }
  }

  @override
  Future<bool> sendBytes(List<int> bytes) async {
    print(
      '--- [WindowsPrinterService] Memulai pengiriman bytes ke: $targetPrinterName ---',
    );

    // Periksa status printer terlebih dahulu
    final statusCheck = await _checkPrinterStatus();
    if (!statusCheck['exists']) {
      print(
        '❌ [WindowsPrinterService] Printer tidak ditemukan: ${statusCheck['error']}',
      );
      Get.snackbar(
        'Printer Tidak Ditemukan',
        'Printer "$targetPrinterName" tidak ditemukan pada sistem',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 211, 47, 47),
        colorText: const Color.fromARGB(255, 255, 255, 255),
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    if (!statusCheck['online']) {
      String errorMsg = 'Printer offline';
      if (statusCheck['offline'] == true) {
        errorMsg = 'Printer "$targetPrinterName" sedang offline';
      } else if (statusCheck['error'] == true) {
        errorMsg = 'Printer "$targetPrinterName" mengalami error';
      } else if (statusCheck['paused'] == true) {
        errorMsg = 'Printer "$targetPrinterName" sedang dijeda';
      }

      print('❌ [WindowsPrinterService] $errorMsg');
      Get.snackbar(
        'Printer Offline',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 211, 47, 47),
        colorText: const Color.fromARGB(255, 255, 255, 255),
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    final pPrinterName = targetPrinterName.toNativeUtf16();
    final phPrinter = calloc<HANDLE>();

    try {
      final result = OpenPrinter(pPrinterName, phPrinter, nullptr);
      if (result == 0) {
        print(
          '❌ [WindowsPrinterService] Gagal OpenPrinter. Error: ${GetLastError()}',
        );
        Get.snackbar(
          'Printer Gagal',
          'Printer "$targetPrinterName" tidak dapat dibuka',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 211, 47, 47),
          colorText: const Color.fromARGB(255, 255, 255, 255),
          duration: const Duration(seconds: 3),
        );
        return false;
      }

      final hPrinter = phPrinter.value;
      final pDocInfo = calloc<DOC_INFO_1>();
      pDocInfo.ref.pDocName = 'POS-ESC-POS-Job'.toNativeUtf16();
      pDocInfo.ref.pOutputFile = nullptr;
      pDocInfo.ref.pDatatype = 'RAW'.toNativeUtf16();

      final dwJob = StartDocPrinter(hPrinter, 1, pDocInfo);
      if (dwJob == 0) {
        print(
          '❌ [WindowsPrinterService] Gagal StartDocPrinter. Error: ${GetLastError()}',
        );
        ClosePrinter(hPrinter);
        return false;
      }

      StartPagePrinter(hPrinter);

      // Alokasi memori lokal ffi untuk raw bytes ESC/POS
      final pBytes = calloc<Uint8>(bytes.length);
      for (int i = 0; i < bytes.length; i++) {
        pBytes[i] = bytes[i];
      }

      final dwBytesWritten = calloc<DWORD>();
      final writeResult = WritePrinter(
        hPrinter,
        pBytes,
        bytes.length,
        dwBytesWritten,
      );

      if (writeResult == 0) {
        print(
          '❌ [WindowsPrinterService] Gagal WritePrinter. Error: ${GetLastError()}',
        );
      } else {
        print(
          '✓ [WindowsPrinterService] Berhasil menulis ${dwBytesWritten.value} bytes ke spooler.',
        );
      }

      EndPagePrinter(hPrinter);
      EndDocPrinter(hPrinter);
      ClosePrinter(hPrinter);

      calloc.free(pBytes);
      calloc.free(dwBytesWritten);
      calloc.free(pDocInfo.ref.pDocName);
      calloc.free(pDocInfo.ref.pDatatype);
      calloc.free(pDocInfo);

      return writeResult != 0;
    } catch (e) {
      print('❌ [WindowsPrinterService] Exception: $e');
      return false;
    } finally {
      calloc.free(pPrinterName);
      calloc.free(phPrinter);
    }
  }
}
