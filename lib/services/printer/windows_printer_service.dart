import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:win32/win32.dart';
import 'printer_service.dart';

class WindowsPrinterService implements PrinterService {
  @override
  final String targetPrinterName;

  WindowsPrinterService({this.targetPrinterName = "Generic / Text Only"});

  @override
  Future<bool> sendBytes(List<int> bytes) async {
    print(
      '--- [WindowsPrinterService] Memulai pengiriman bytes ke: $targetPrinterName ---',
    );

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
