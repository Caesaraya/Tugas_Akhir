import 'package:flutter/material.dart';

class TablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const TablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Teks Informasi Halaman di Sebelah Kiri (Showing X of Y)
          Text(
            "Showing $currentPage of $totalPages pages",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          // Tombol Navigasi Kotak Modern di Sebelah Kanan
          Row(
            children: [
              // Tombol Previous (<)
              _buildPaginationButton(
                icon: Icons.chevron_left_rounded,
                onTap: currentPage > 1 ? onPrevious : null,
                primaryColor: primaryColor,
              ),

              const SizedBox(width: 8),

              // Kotak Indikator Halaman Aktif (Angka di Tengah)
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "$currentPage",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Tombol Next (>)
              _buildPaginationButton(
                icon: Icons.chevron_right_rounded,
                onTap: currentPage < totalPages ? onNext : null,
                primaryColor: primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required VoidCallback? onTap,
    required Color primaryColor,
  }) {
    final bool isDisabled = onTap == null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDisabled ? Colors.grey.shade200 : Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: isDisabled ? Colors.grey.shade300 : primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}
