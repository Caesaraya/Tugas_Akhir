import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/qris_controller.dart';

class QrisPaymentPage extends StatelessWidget {
  const QrisPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Menginisialisasi QrisController jika belum ada di GetX dependency
    final QrisController qrisController = Get.put(QrisController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran QRIS',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- BOX TOTAL TAGIHAN ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Tagihan',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        qrisController.totalFormatted,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // --- QRIS IMAGE ---
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/rumah1.jpg', // Gambar QRIS Toko
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 220,
                        height: 220,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.qr_code_2,
                          size: 100,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- AMBIL / PREVIEW BUKTI PEMBAYARAN ---
            Obx(() {
              final file = qrisController.imageFile.value;

              if (file == null) {
                return OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.orange),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: qrisController.pickProofOfPayment,
                  icon: Icon(
                    GetPlatform.isDesktop
                        ? Icons.upload_file
                        : Icons.camera_alt,
                    color: Colors.orange,
                  ),
                  label: Text(
                    GetPlatform.isDesktop
                        ? 'Pilih Bukti Pembayaran (File)'
                        : 'Ambil Bukti Pembayaran (Kamera)',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb
                          ? Image.network(file.path, fit: BoxFit.cover)
                          : Image.file(file, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: qrisController.retakePhoto,
                    icon: const Icon(Icons.refresh, color: Colors.red),
                    label: Text(
                      GetPlatform.isDesktop ? 'Ganti File' : 'Foto Ulang',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),

            // --- CHECKBOX VERIFIKASI ---
            Obx(
              () => CheckboxListTile(
                value: qrisController.isVerified.value,
                onChanged: qrisController.toggleVerification,
                activeColor: Colors.orange,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Saya telah memverifikasi bukti pembayaran.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- TOMBOL BAYAR ---
            Obx(() {
              final isReady =
                  qrisController.imageFile.value != null &&
                  qrisController.isVerified.value;

              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isReady
                      ? Colors.orange
                      : Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isReady ? qrisController.processQrisPayment : null,
                child: const Text(
                  'Bayar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
