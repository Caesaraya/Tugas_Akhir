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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        Text(
          "$currentPage / $totalPages",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.arrow_forward_ios),
        ),
      ],
    );
  }
}
