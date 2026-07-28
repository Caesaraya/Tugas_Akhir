import 'package:flutter/material.dart';

class LangkahPembayaranCard extends StatelessWidget {
  const LangkahPembayaranCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Langkah Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 12),
          LangkahStep(no: '1', text: 'Scan QR code di atas'),
          LangkahStep(no: '2', text: 'Selesaikan pembayaran'),
          LangkahStep(no: '3', text: 'Tunjukkan bukti pembayaran'),
          LangkahStep(no: '4', text: 'Pilih foto bukti'),
          LangkahStep(no: '5', text: 'Tekan tombol "Bayar" untuk simpan transaksi'),
        ],
      ),
    );
  }
}

/// Satu baris langkah bernomor bulat + teks.
class LangkahStep extends StatelessWidget {
  final String no;
  final String text;

  const LangkahStep({super.key, required this.no, required this.text});

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