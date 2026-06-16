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
            // Baris Navigasi Tombol Angka (Strict Maksimal 4 Pilihan Kotak)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquareNavButton(
                  icon: Icons.chevron_left,
                  onPressed: current > 1 ? controller.previousPage : null,
                ),
                const SizedBox(width: 4),

                // Memanggil builder item pagination maksimal 4 komponen
                ..._buildStrictFourItems(current, total),

                const SizedBox(width: 4),
                _buildSquareNavButton(
                  icon: Icons.chevron_right,
                  onPressed: current < total ? controller.nextPage : null,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Keterangan Total Data di Bagian Bawah
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

  /// Menghasilkan maksimal hanya 4 kotak elemen (Angka / Titik) di layar
  List<Widget> _buildStrictFourItems(int current, int total) {
    List<Widget> items = [];

    if (total <= 4) {
      for (int i = 1; i <= total; i++) {
        items.add(_buildPageBox(i.toString(), i == current, i));
      }
      return items;
    }

    // Kondisi pembatasan ketat 4 item saat total halaman > 4
    if (current <= 2) {
      items.add(_buildPageBox('1', current == 1, 1));
      items.add(_buildPageBox('2', current == 2, 2));
      items.add(_buildEllipsisSign());
      items.add(_buildPageBox(total.toString(), false, total));
    } else if (current >= total - 1) {
      items.add(_buildPageBox('1', false, 1));
      items.add(_buildEllipsisSign());
      items.add(
        _buildPageBox((total - 1).toString(), current == total - 1, total - 1),
      );
      items.add(_buildPageBox(total.toString(), current == total, total));
    } else {
      items.add(_buildPageBox('1', false, 1));
      items.add(_buildEllipsisSign());
      items.add(_buildPageBox(current.toString(), true, current));
      items.add(_buildPageBox(total.toString(), false, total));
    }

    return items;
  }

  Widget _buildPageBox(String label, bool isActive, int targetPage) {
    return InkWell(
      onTap: isActive
          ? null
          : () {
              controller.currentPage.value = targetPage;
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

  Widget _buildEllipsisSign() {
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

  Widget _buildSquareNavButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
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
