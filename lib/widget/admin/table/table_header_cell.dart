import 'package:flutter/material.dart';
import 'package:tugas_akhir/utils/app_color.dart';

class TableHeaderCell extends StatelessWidget {
  final String title;
  final double width;
  final double height;

  const TableHeaderCell({
    super.key,
    required this.title,
    required this.width,
    this.height = 42,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.black;

    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
