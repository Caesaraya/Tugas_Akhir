import 'package:flutter/material.dart';

class TableRowCell extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final Widget? child;
  final Color? backgroundColor;

  const TableRowCell({
    super.key,
    required this.text,
    required this.width,
    this.height = 44,
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child:
          child ??
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
    );
  }
}
