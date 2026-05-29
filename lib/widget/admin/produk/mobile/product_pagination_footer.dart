import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/admin/product_table_controller.dart';

class ProductPaginationFooter extends StatelessWidget {
  final ProductTableController controller;

  const ProductPaginationFooter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final int current = controller.currentPage.value;
      final int total = controller.totalPages.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: const Color(0xFFF8F9FA),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris Navigasi Tombol Angka (Maksimal 4 Pilihan)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Back (<)
                _buildSquareNav(
                  icon: Icons.chevron_left,
                  onPressed: current > 1 ? controller.previousPage : null,
                ),
                const SizedBox(width: 4),

                // Render Item Angka Pagination (Maksimal 4 Elemen)
                ..._buildStrictFourPaginationItems(current, total),

                const SizedBox(width: 4),
                // Tombol Next (>)
                _buildSquareNav(
                  icon: Icons.chevron_right,
                  onPressed: current < total ? controller.nextPage : null,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Teks Keterangan Total Produk di Bagian Bawah
            Text(
              'Menampilkan ${controller.paginatedList.length} dari ${controller.filteredList.length} produk',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    });
  }

  /// Fungsi khusus untuk menghasilkan maksimal 4 elemen pilihan pagination
  List<Widget> _buildStrictFourPaginationItems(int current, int total) {
    List<Widget> items = [];

    // Kondisi 1: Jika total halaman kurang dari atau sama dengan 4, tampilkan semua angka langsung
    if (total <= 4) {
      for (int i = 1; i <= total; i++) {
        items.add(_buildPageNumber(i.toString(), i == current, i));
      }
      return items;
    }

    // Kondisi 2: Jika total halaman banyak (> 4), kita batasi ketat hanya 4 item
    // Skenario A: Masih di halaman awal (Halaman 1 atau 2 aktif) -> Tampilkan: [1] [2] [...] [Total]
    if (current <= 2) {
      items.add(_buildPageNumber('1', current == 1, 1));
      items.add(_buildPageNumber('2', current == 2, 2));
      items.add(_buildEllipsis());
      items.add(_buildPageNumber(total.toString(), false, total));
    }
    // Skenario B: Sudah mendekati halaman akhir (Halaman terakhir atau Halaman terakhir - 1 aktif) -> Tampilkan: [1] [...] [Total-1] [Total]
    else if (current >= total - 1) {
      items.add(_buildPageNumber('1', false, 1));
      items.add(_buildEllipsis());
      items.add(
        _buildPageNumber(
          (total - 1).toString(),
          current == total - 1,
          total - 1,
        ),
      );
      items.add(_buildPageNumber(total.toString(), current == total, total));
    }
    // Skenario C: Di tengah-tengah (Misal total 10, sedang di halaman 5) -> Tampilkan: [1] [...] [Current] [Total]
    else {
      items.add(_buildPageNumber('1', false, 1));
      items.add(_buildEllipsis());
      items.add(_buildPageNumber(current.toString(), true, current));
      items.add(_buildPageNumber(total.toString(), false, total));
    }

    return items;
  }

  /// Widget Kotak Angka (Hitam jika aktif, Putih jika tidak aktif)
  Widget _buildPageNumber(String label, bool isActive, int pageTarget) {
    return InkWell(
      onTap: isActive
          ? null
          : () {
              controller.currentPage.value = pageTarget;
              controller.setupPagination();
            },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          border: isActive ? null : Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  /// Widget penanda jeda halaman [...]
  Widget _buildEllipsis() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '...',
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  /// Widget tombol navigasi panah < dan >
  Widget _buildSquareNav({required IconData icon, VoidCallback? onPressed}) {
    bool isDisable = onPressed == null;
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDisable ? Colors.grey[100] : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDisable ? Colors.grey : Colors.black87,
        ),
      ),
    );
  }
}
