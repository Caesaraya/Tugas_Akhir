import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

class QrisController extends GetxController {
  final CartController cartController = Get.find<CartController>();
  final ImagePicker _picker = ImagePicker();

  // Variabel untuk menyimpan berkas bukti pembayaran
  var imageFile = Rxn<File>();
  var isVerified = false.obs;
  var isLoading = false.obs;

  String get totalFormatted =>
      cartController.currencyFormatter.format(cartController.totalPrice);

  /// Mengambil foto bukti pembayaran (Multi-platform)
  Future<void> pickProofOfPayment() async {
    try {
      if (GetPlatform.isMobile) {
        // Platform Android / iOS: Gunakan Kamera
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          imageFile.value = File(pickedFile.path);
        }
      } else if (GetPlatform.isWindows || GetPlatform.isDesktop) {
        // Platform Windows / Desktop: Gunakan File Picker
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
        );

        if (result != null && result.files.single.path != null) {
          imageFile.value = File(result.files.single.path!);
        }
      } else {
        // Fallback untuk Web atau platform lain
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
        );
        if (result != null && result.files.single.path != null) {
          imageFile.value = File(result.files.single.path!);
        }
      }

      // TODO: Panggil fungsi OCR di sini setelah foto berhasil diisi jika diperlukan
    } catch (e) {
      Get.snackbar(
        'Gagal Ambil Gambar',
        'Terjadi kesalahan saat memilih gambar: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Menghapus / Mengambil ulang foto
  void retakePhoto() {
    imageFile.value = null;
    isVerified.value = false;
  }

  /// Mengubah status verifikasi manual oleh kasir
  void toggleVerification(bool? value) {
    isVerified.value = value ?? false;
  }

  /// Memproses pembayaran QRIS dan melanjutkan ke halaman sukses/selesai
  void processQrisPayment() {
    if (imageFile.value == null) {
      Get.snackbar(
        'Bukti Pembayaran',
        'Silakan ambil foto atau upload bukti pembayaran terlebih dahulu.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isVerified.value) {
      Get.snackbar(
        'Verifikasi Pembayaran',
        'Centang konfirmasi bahwa pembayaran sudah sesuai.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    cartController.selectedPayment.value = 'qris';
    cartController.inputUang.value = cartController.totalPrice;

    if (GetPlatform.isDesktop) {
      Get.offAllNamed(AppRoutes.kasirprint);
    } else {
      Get.toNamed(AppRoutes.sukses);
    }
  }
}
