import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'printer_service.dart';

class BluetoothPrinterService implements PrinterService {
  @override
  final String targetPrinterName;

  // Ambil instance singleton dari blue_thermal_printer
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  bool _isConnected = false;

  BluetoothPrinterService({required this.targetPrinterName});

  /// Fungsi internal untuk menyambungkan socket bluetooth device yang sudah paired
  Future<bool> _ensureConnected() async {
    // Jika status internal mencatat sudah terhubung, cek validitasnya ke hardware
    bool? isConnectedDevice = await bluetooth.isConnected;
    if (_isConnected && isConnectedDevice == true) return true;

    print(
      '⏳ [BluetoothPrinterService] Mencoba menghubungkan ke socket Bluetooth $targetPrinterName...',
    );
    try {
      // 1. Cek apakah bluetooth sistem aktif
      bool? isOn = await bluetooth.isOn;
      if (isOn != true) {
        print(
          '❌ [BluetoothPrinterService] Batalkan: Bluetooth smartphone Anda tidak aktif.',
        );
        Get.snackbar(
          'Bluetooth Tidak Aktif',
          'Aktifkan Bluetooth di pengaturan perangkat Anda',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 211, 47, 47),
          colorText: const Color.fromARGB(255, 255, 255, 255),
          duration: const Duration(seconds: 3),
        );
        return false;
      }

      // 2. Ambil daftar perangkat yang sudah PAIRED di Android HP
      List<BluetoothDevice> devices = await bluetooth.getBondedDevices();

      // 3. Cari printer yang namanya cocok ("RPP02N")
      BluetoothDevice? targetDevice;
      for (var d in devices) {
        if (d.name == targetPrinterName) {
          targetDevice = d;
          break;
        }
      }

      // 4. Jika ketemu, lakukan instruksi koneksi socket
      if (targetDevice != null) {
        await bluetooth.connect(targetDevice);
        _isConnected = true;
        print(
          '✓ [BluetoothPrinterService] Socket Bluetooth Terhubung Berhasil!',
        );
        return true;
      }

      print(
        '❌ [BluetoothPrinterService] Device dengan nama "$targetPrinterName" tidak ditemukan di daftar paired.',
      );
      Get.snackbar(
        'Printer Tidak Ditemukan',
        'Printer "$targetPrinterName" tidak ditemukan. Pastikan printer sudah di-pair di pengaturan Bluetooth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 211, 47, 47),
        colorText: const Color.fromARGB(255, 255, 255, 255),
        duration: const Duration(seconds: 3),
      );
      return false;
    } catch (e) {
      print(
        '❌ [BluetoothPrinterService] Gagal menghubungkan socket hardware: $e',
      );
      Get.snackbar(
        'Koneksi Printer Gagal',
        'Terjadi kesalahan saat menghubungkan ke printer: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 211, 47, 47),
        colorText: const Color.fromARGB(255, 255, 255, 255),
        duration: const Duration(seconds: 3),
      );
      _isConnected = false;
      return false;
    }
  }

  @override
  Future<bool> sendBytes(List<int> bytes) async {
    print(
      '--- [BluetoothPrinterService] Mengirim bytes ke device Bluetooth: $targetPrinterName ---',
    );

    // Pastikan koneksi terbuka sebelum menulis data stream
    bool connected = await _ensureConnected();
    if (!connected) {
      print(
        '❌ [BluetoothPrinterService] Cetak dibatalkan: Koneksi Bluetooth gagal disiapkan.',
      );
      Get.snackbar(
        'Printer Tidak Terkoneksi',
        'Gagal menghubungkan ke printer $targetPrinterName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 211, 47, 47),
        colorText: const Color.fromARGB(255, 255, 255, 255),
        duration: const Duration(seconds: 3),
      );
      return false;
    }

    try {
      // Kirim data uint8list ke printer via package stream channel
      await bluetooth.writeBytes(Uint8List.fromList(bytes));

      print(
        '✓ [BluetoothPrinterService] Data bytes sukses dikirim ke printer hardware Android.',
      );
      return true;
    } catch (e) {
      print('❌ [BluetoothPrinterService] Error saat transmisi data stream: $e');
      Get.snackbar(
        'Gagal Mengirim Data',
        'Printer terputus saat mengirim data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color.fromARGB(255, 211, 47, 47),
        colorText: const Color.fromARGB(255, 255, 255, 255),
        duration: const Duration(seconds: 3),
      );
      _isConnected = false; // Reset status jika transmisi putus di tengah jalan
      return false;
    }
  }
}
