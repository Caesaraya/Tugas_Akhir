import 'package:flutter/material.dart';

class TableHeaderCell extends StatelessWidget {
  final String title;
  final double width;

  const TableHeaderCell({super.key, required this.title, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        color: Colors.grey.shade300,
      ),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
