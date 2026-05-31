import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/controller/admin/bahan_baku_table_controller.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/page/admin/mobile/bahanbaku/bahan_baku_detail_page.dart';

class BahanBakuItemCard extends StatelessWidget {
  final BahanBaku item;
  final BahanBakuTableController controller;
  final NumberFormat formatCurrency;

  const BahanBakuItemCard({
    super.key,
    required this.item,
    required this.controller,
    required this.formatCurrency,
  });

  @override
  Widget build(BuildContext context) {
    final isDeleted = item.deletedAt != null;

    // Format konversi angka desimal agar rapi tanpa .0 jika bilangan bulat
    final String displayStok = item.stok == item.stok.roundToDouble()
        ? item.stok.toInt().toString()
        : item.stok.toString();

    // Penentuan warna status berdasarkan ketersediaan stok bahan baku
    Color stockColor = Colors.green;
    if (isDeleted) {
      stockColor = Colors.grey;
    } else if (item.stok == 0) {
      stockColor = Colors.red;
    } else if (item.stok <= 5) {
      stockColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDeleted ? Colors.red.shade50.withOpacity(0.4) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDeleted ? Colors.red.shade200 : Colors.grey.shade200,
        ),
      ),
      child: InkWell(
        onTap: () => Get.to(() => BahanBakuDetailPage(bahanBaku: item)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Ikon Pengganti representasi visual di Sisi Kiri
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                color: Colors.black54,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),

            // 2. Blok Detail Konten Sisi Kanan (Atas & Bawah)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sisi Atas: Nama & Merk Bahan di kiri, Harga di Kanan Atas
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.namaBahan,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.merk.isEmpty ? '-' : item.merk,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formatCurrency.format(item.hargaSatuan),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Sisi Bawah: Status Indikator Lingkaran Stok & Tombol Navigasi Aksi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Indikator Titik Status Stok
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: stockColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isDeleted
                                ? 'Terhapus'
                                : 'Stok: $displayStok ${item.satuan}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      // Kumpulan Tombol Aksi Berwarna di Kanan Bawah
                      Row(
                        children: isDeleted
                            ? [
                                // JIKA DELETED = TRUE (Menampilkan Restore & Hapus Permanen)
                                _buildActionIconButton(
                                  icon: Icons.restore_outlined,
                                  color:
                                      Colors.green, // Warna Hijau untuk Restore
                                  onTap: () =>
                                      controller.restoreBahan(item.id!),
                                ),
                                const SizedBox(width: 6),
                                _buildActionIconButton(
                                  icon: Icons.delete_forever_outlined,
                                  color: Colors
                                      .red
                                      .shade900, // Merah tua untuk hapus permanen
                                  onTap: () =>
                                      controller.forceDeleteBahan(item.id!),
                                ),
                              ]
                            : [
                                _buildActionIconButton(
                                  icon: Icons.edit_outlined,
                                  color: Colors.blue, // Warna Biru untuk Edit
                                  onTap: () => controller.showEditDialog(item),
                                ),
                                const SizedBox(width: 6),
                                _buildActionIconButton(
                                  icon: Icons.delete_outline_rounded,
                                  color: Colors.red, // Warna Merah untuk Hapus
                                  onTap: () =>
                                      controller.softDeleteBahan(item.id!),
                                ),
                              ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
