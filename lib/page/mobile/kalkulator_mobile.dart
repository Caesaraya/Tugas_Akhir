import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/mobile/cart_controller.dart';
import 'package:tugas_akhir/page/mobile/sukses_mobile_page.dart';
import 'package:tugas_akhir/widget/widget%20mobile/kalkulator_input.dart';
import 'package:intl/intl.dart'; 
import 'package:tugas_akhir/widget/widget%20mobile/CurrencyInputFormatter.dart';

class KalkulatorCashPage extends StatelessWidget {
  final CartController cartController = Get.find();

  // Inisialisasi formatter untuk tampilan teks
  final currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Pembayaran Tunai",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Box Total Tagihan
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Total Tagihan",
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currencyFormatter.format(cartController.totalPrice),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Masukkan Uang Diterima",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  
                  // Input Kalkulator dengan Formatter Titik Otomatis
                  KalkulatorInput(
                    controller: cartController.textController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(), 
                    ],
                    onChanged: (value) {
                      // Membersihkan titik agar tersimpan sebagai angka murni di controller
                      String cleanValue = value.replaceAll('.', '');
                      cartController.setInputUang(cleanValue);
                    },
                  ),
                  
                  const SizedBox(height: 60),
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          "Kembalian",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            currencyFormatter.format(cartController.kembalian),
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              // Warna berubah merah jika uang belum cukup
                              color: cartController.isUangCukup
                                  ? Colors.green
                                  : Colors.red[300],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Button Konfirmasi & Bayar
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // Tombol menyala oranye jika ada input > 0
                    backgroundColor: cartController.hasInputUang 
                        ? const Color(0xFFE89336) 
                        : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  onPressed: cartController.hasInputUang 
                      ? () {
                          if (cartController.isUangCukup) {
                            // Jika cukup, pindah ke halaman sukses
                            Get.offAll(() => SuksesMobilePage());
                          } else {
                            // Jika belum cukup, munculkan peringatan
                            Get.snackbar(
                              "Uang Kurang",
                              "Uang diterima belum mencukupi total tagihan",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              margin: const EdgeInsets.all(16),
                              icon: const Icon(Icons.warning, color: Colors.white),
                            );
                          }
                        }
                      : null,
                  child: const Text(
                    "Konfirmasi & Bayar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}