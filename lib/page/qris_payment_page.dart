import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tugas_akhir/controller/cart_controller.dart';
import 'package:tugas_akhir/routes/routes.dart';

class QrisPaymentPage extends StatefulWidget {
  const QrisPaymentPage({super.key});

  @override
  State<QrisPaymentPage> createState() => QrisPaymentPageState();
}

class QrisPaymentPageState extends State<QrisPaymentPage> {
  File? buktiFoto;
  bool isLoading = false;
  bool sudahKonfirmasi = false;
  final CartController cartCtrl = Get.find<CartController>();

  Future<void> pilihFoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        buktiFoto = File(picked.path);
        sudahKonfirmasi = false;
      });
    }
  }

  Future<void> prosesBayar() async {
    if (buktiFoto == null) return;
    setState(() => isLoading = true);
    try {
      cartCtrl.selectedPayment.value = 'qris';
      cartCtrl.inputUang.value = cartCtrl.totalPrice;
      Get.offAllNamed(AppRoutes.sukses);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      appBar: AppBar(
        title: const Text(
          'Pembayaran QRIS',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Total tagihan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Tagihan',
                    style: TextStyle(fontSize: 14, color: Color(0xFFE89336)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cartCtrl.currencyFormatter.format(cartCtrl.totalPrice),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ✅ QR Code placeholder
            Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Ganti dengan Image.asset('assets/qris.png') saat QR tersedia
                  Icon(Icons.qr_code_2, size: 150, color: Colors.grey.shade800),
                  const SizedBox(height: 8),
                  Text(
                    'Scan untuk membayar',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Scan QR di atas menggunakan aplikasi e-wallet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),

            // ✅ Langkah-langkah
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Langkah Pembayaran',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Step(no: '1', text: ' scan QR code di atas'),
                  Step(no: '2', text: ' selesaikan pembayaran'),
                  Step(no: '3', text: ' tunjukkan bukti pembayaran'),
                  Step(no: '4', text: ' pilih foto bukti '),
                  Step(
                    no: '5',
                    text: 'Tekan tombol "Bayar" untuk simpan transaksi',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ✅ Area foto bukti
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Foto Bukti Pembayaran',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: pilihFoto,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: buktiFoto != null
                        ? const Color(0xFFE89336)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: buktiFoto != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.file(buktiFoto!, fit: BoxFit.cover),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap untuk pilih foto bukti dari gallery',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            if (buktiFoto != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: sudahKonfirmasi,
                      activeColor: const Color(0xFFE89336),
                      onChanged: (val) =>
                          setState(() => sudahKonfirmasi = val ?? false),
                    ),
                    const Expanded(
                      child: Text(
                        'Saya konfirmasi foto di atas adalah bukti pembayaran QRIS yang valid',
                        style: TextStyle(fontSize: 12, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: buktiFoto != null && sudahKonfirmasi && !isLoading
                    ? prosesBayar
                    : null,

                // Teks tombol:
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        buktiFoto == null
                            ? 'Pilih Foto Bukti Dahulu'
                            :  sudahKonfirmasi
                            ? 'Konfirmasi Bukti Dahulu'
                            : 'Bayar Sekarang',
                        style: TextStyle(
                          color: buktiFoto != null && sudahKonfirmasi
                              ? Colors.green
                              : Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class Step extends StatelessWidget {
  final String no;
  final String text;
  const Step({required this.no, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFFE89336),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                no,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
