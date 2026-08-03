import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/Qris_controller.dart';
import 'package:tugas_akhir/widget/widget%20mobile/Qris/Konfirm.dart';
import 'package:tugas_akhir/widget/widget%20mobile/Qris/Qrcode_card.dart';
import 'package:tugas_akhir/widget/widget%20mobile/Qris/Tagihan.dart';
import 'package:tugas_akhir/widget/widget%20mobile/Qris/Tutorial.dart';
import 'package:tugas_akhir/widget/widget%20mobile/Qris/bayar_button.dart';
import 'package:tugas_akhir/widget/widget%20mobile/Qris/bukti.dart';

class QrisPaymentPage extends StatelessWidget {
  const QrisPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final QrisPaymentController ctrl = Get.put(QrisPaymentController());

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
            Obx(() => TotalTagihanCard(totalFormatted: ctrl.totalFormatted)),
            const SizedBox(height: 24),
            const QrCodeCard(),
            const SizedBox(height: 24),
            const LangkahPembayaranCard(),
            const SizedBox(height: 24),
            Obx(
              () => BuktiFotoPicker(
                buktiFoto: ctrl.buktiFoto.value,
                onTap: ctrl.pilihFoto,
              ),
            ),
            Obx(() {
              if (ctrl.buktiFoto.value == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: KonfirmasiCheckbox(
                  value: ctrl.sudahKonfirmasi.value,
                  onChanged: ctrl.toggleKonfirmasi,
                ),
              );
            }),
            const SizedBox(height: 24),
            Obx(
              () => BayarButton(
                hasFoto: ctrl.buktiFoto.value != null,
                sudahKonfirmasi: ctrl.sudahKonfirmasi.value,
                isLoading: ctrl.isLoading.value,
                onPressed: ctrl.canBayar ? ctrl.prosesBayar : null,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
