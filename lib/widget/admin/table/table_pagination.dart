import 'package:flutter/material.dart';

class TablePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final Function(int)?
  onPageSelected; // Opsional: Untuk navigasi langsung via angka

  const TablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onPrevious,
    this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: const Color(
        0xFFF8F9FA,
      ), // Background abu-abu terang sesuai tema produk
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.end, // Membawa seluruh konten ke pojok kanan
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end, // Meratakan teks dan tombol ke kanan
            mainAxisSize: MainAxisSize.min,
            children: [
              // Baris Navigasi Tombol Angka (Strict Maksimal 4 Pilihan Kotak)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildSquareNavButton(
                    icon: Icons.chevron_left,
                    onPressed: currentPage > 1 ? onPrevious : null,
                  ),
                  const SizedBox(width: 4),

                  // Memanggil builder item pagination maksimal 4 komponen
                  ..._buildStrictFourItems(currentPage, totalPages),

                  const SizedBox(width: 4),
                  _buildSquareNavButton(
                    icon: Icons.chevron_right,
                    onPressed: currentPage < totalPages ? onNext : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Keterangan Total Halaman di Bagian Bawah
              Text(
                "Menampilkan halaman $currentPage dari $totalPages",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
              if (onPageSelected != null) {
                onPageSelected!(targetPage);
              }
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
