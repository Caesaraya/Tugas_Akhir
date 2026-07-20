import 'package:flutter/material.dart';
import 'package:tugas_akhir/models/resep.dart';

class BakeryResepCard extends StatelessWidget {
  final Resep resep;
  final VoidCallback onTap;

  const BakeryResepCard({super.key, required this.resep, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final jumlahBahan = resep.bahan?.length ?? 0;
    final jumlahProduk = resep.products?.length ?? 0;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
         color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: const Color(0xFFE89336).withValues(alpha: 0.08),
                      child: const Icon(
                        Icons.menu_book_outlined,
                        size: 52,
                        color: Color(0xFFE89336),
                      ),
                    ),
                  ),
                  // Badge jumlah produk terkait
                  if (jumlahProduk > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE89336),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            jumlahProduk.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 34,
                    child: Text(
                      resep.namaResep,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    resep.deskripsi.isNotEmpty
                        ? resep.deskripsi
                        : 'Tidak ada deskripsi',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[500], fontSize: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
