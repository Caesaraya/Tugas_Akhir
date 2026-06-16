import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin/resep_table_controller.dart';

class ResepPaginationFooter extends StatelessWidget {
  final ResepTableController controller;

  const ResepPaginationFooter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Mengambil reactive state halaman langsung dari BaseTableController
      final int current = controller.currentPage.value;
      final int total = controller.totalPages.value;

      // Jika total halaman kurang dari atau sama dengan 1, footer tidak perlu muncul (sama seperti produk)
      if (total <= 1) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        color: const Color(
          0xFFF8F9FA,
        ), // Latar belakang abu-abu terang sesuai product footer
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris Navigasi Tombol Angka (Maksimal 4 Pilihan Kotak Sesuai Produk)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSquareNavButton(
                  icon: Icons.chevron_left,
                  // Menggunakan previousPage bawaan controller
                  onPressed: current > 1 ? controller.previousPage : null,
                ),
                const SizedBox(width: 4),

                // Memanggil pembentuk item pagination kotak maksimal 4 komponen
                ..._buildStrictFourItems(current, total),

                const SizedBox(width: 4),
                _buildSquareNavButton(
                  icon: Icons.chevron_right,
                  // Menggunakan nextPage bawaan controller
                  onPressed: current < total ? controller.nextPage : null,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  /// Algoritma untuk menghasilkan susunan item kotak halaman (Maksimal 4 Komponen)
  List<Widget> _buildStrictFourItems(int current, int total) {
    List<Widget> items = [];

    if (total <= 4) {
      for (int i = 1; i <= total; i++) {
        items.add(
          _buildPageNumberBox(
            i.toString(),
            isActive: i == current,
            pageTarget: i,
          ),
        );
        if (i < total) items.add(const SizedBox(width: 4));
      }
    } else {
      if (current <= 2) {
        items.add(
          _buildPageNumberBox('1', isActive: current == 1, pageTarget: 1),
        );
        items.add(const SizedBox(width: 4));
        items.add(
          _buildPageNumberBox('2', isActive: current == 2, pageTarget: 2),
        );
        items.add(const SizedBox(width: 4));
        items.add(_buildPageNumberBox('3', isActive: false, pageTarget: 3));
        items.add(const SizedBox(width: 4));
        items.add(_buildEllipsisSign());
      } else if (current >= total - 1) {
        items.add(_buildPageNumberBox('1', isActive: false, pageTarget: 1));
        items.add(const SizedBox(width: 4));
        items.add(_buildEllipsisSign());
        items.add(const SizedBox(width: 4));
        items.add(
          _buildPageNumberBox(
            '${total - 2}',
            isActive: false,
            pageTarget: total - 2,
          ),
        );
        items.add(const SizedBox(width: 4));
        items.add(
          _buildPageNumberBox(
            '${total - 1}',
            isActive: current == total - 1,
            pageTarget: total - 1,
          ),
        );
        items.add(const SizedBox(width: 4));
        items.add(
          _buildPageNumberBox(
            '$total',
            isActive: current == total,
            pageTarget: total,
          ),
        );
      } else {
        items.add(_buildPageNumberBox('1', isActive: false, pageTarget: 1));
        items.add(const SizedBox(width: 4));
        items.add(_buildEllipsisSign());
        items.add(const SizedBox(width: 4));
        items.add(
          _buildPageNumberBox('$current', isActive: true, pageTarget: current),
        );
        items.add(const SizedBox(width: 4));
        items.add(_buildEllipsisSign());
      }

      if (current < total - 1) {
        items.add(const SizedBox(width: 4));
        items.add(
          _buildPageNumberBox('$total', isActive: false, pageTarget: total),
        );
      }
    }

    return items;
  }

  Widget _buildPageNumberBox(
    String label, {
    required bool isActive,
    required int pageTarget,
  }) {
    return InkWell(
      // Solusi tanpa goToPage: langsung mutasi nilai RxInt currentPage dan panggil fetchData()
      onTap: isActive
          ? null
          : () {
              controller.currentPage.value = pageTarget;
              controller.fetchData();
            },
      child: Container(
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
          color: isDisable ? Colors.grey.shade400 : Colors.black87,
          size: 20,
        ),
      ),
    );
  }
}
