import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalCount;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final String itemName;
  final bool canGoPrevious;
  final bool canGoNext;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.onPreviousPage,
    required this.onNextPage,
    this.itemName = 'item',
    required this.canGoPrevious,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    final start = totalCount == 0 ? 0 : ((currentPage - 1) * pageSize) + 1;
    final end = totalCount == 0 ? 0 : start + pageSize - 1;
    final displayEnd = end > totalCount ? totalCount : end;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Menampilkan $start–$displayEnd dari $totalCount $itemName',
            style: const TextStyle(fontSize: 14),
          ),
          Row(
            children: [
              IconButton(
                onPressed: canGoPrevious ? onPreviousPage : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Text('$currentPage / $totalPages'),
              IconButton(
                onPressed: canGoNext ? onNextPage : null,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
