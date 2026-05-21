import 'package:flutter/material.dart';

class TableActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const TableActionButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            // Memberikan warna latar belakang yang sangat lembut (12% intensitas warna asli)
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.25), width: 1),
          ),
          child: Icon(
            icon,
            color:
                color, // Ikon terlihat tajam karena background-nya soft/terang
            size: 16,
          ),
        ),
      ),
    );
  }
}
