import 'package:flutter/material.dart';

class ReceiptRowItem extends StatelessWidget {
  final String title;
  final String value;
  final double fontSize;
  final FontWeight valueFontWeight;

  const ReceiptRowItem({
    super.key,
    required this.title,
    required this.value,
    this.fontSize = 16,
    this.valueFontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: fontSize)),
          Text(
            value,
            style: TextStyle(fontSize: fontSize, fontWeight: valueFontWeight),
          ),
        ],
      ),
    );
  }
}

class ReceiptProductRow extends StatelessWidget {
  final String name;
  final int qty;
  final double unitPrice;
  final double totalPrice;

  const ReceiptProductRow({
    super.key,
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(name, style: const TextStyle(fontSize: 14))),
          Text("x$qty", style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 12),
          Text(
            "Rp ${totalPrice.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ReceiptActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;

  const ReceiptActionButton({
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = Colors.orange,
    this.textColor = Colors.white,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(label, style: TextStyle(color: textColor)),
      ),
    );
  }
}
