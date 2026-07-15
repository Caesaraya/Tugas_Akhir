import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardKeuangan extends StatelessWidget {
  final String judul;
  final double nominal;
  final String subJudul;
  final IconData icon;
  final Color warnaAksen;

  const CardKeuangan({
    super.key,
    required this.judul,
    required this.nominal,
    required this.subJudul,
    required this.icon,
    required this.warnaAksen,
  });

  @override
  Widget build(BuildContext context) {
    final rupiah = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      // Menggunakan Expanded agar lebar kartu sama rata dalam Row
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Atas
              Text(
                judul.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.1,
                ),
              ),
              const SizedBox(height: 16),

              // Angka Nominal Besar
              Text(
                rupiah.format(nominal),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Baris Bawah (Subtitle & Icon)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Teks Keterangan di bawah
                  Text(
                    subJudul,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: warnaAksen,
                    ),
                  ),

                  // Kotak Ikon di Pojok Kanan Bawah
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: warnaAksen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: warnaAksen.withOpacity(0.5),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
