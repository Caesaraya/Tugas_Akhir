import 'package:flutter/material.dart';

class TableRowCell extends StatelessWidget {
  final String text;
  final double width;
  final Widget? child;

  const TableRowCell({
    super.key,
    required this.text,
    required this.width,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black54)),

      child:
          child ??
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            textAlign: TextAlign.center,
          ),
    );
  }
}
