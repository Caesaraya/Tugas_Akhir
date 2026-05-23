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
    final primaryColor = const Color(
      0xFF1E1E1E,
    ); // Diselaraskan dengan hitam tema utama

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Menampilkan halaman $currentPage dari $totalPages",
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            _buildPaginationButton(
              icon: Icons.chevron_left_rounded,
              onTap: currentPage > 1 ? onPrevious : null,
              primaryColor: primaryColor,
            ),
            const SizedBox(width: 8),
            Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
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
            _buildPaginationButton(
              icon: Icons.chevron_right_rounded,
              onTap: currentPage < totalPages ? onNext : null,
              primaryColor: primaryColor,
            ),
          ],
        ),
      ],
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
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDisabled ? Colors.grey.shade100 : Colors.grey.shade300,
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
