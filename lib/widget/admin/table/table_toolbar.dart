import 'package:flutter/material.dart';

class ToolbarButton extends StatelessWidget {
  final String? title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ToolbarButton({
    super.key,
    this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIconOnly = title == null || title!.isEmpty;

    return SizedBox(
      height: 42, // Membuat tinggi tombol lebih kompak & proporsional
      width: isIconOnly ? 42 : null,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8,
            ), // Mengikuti sudut rounded sidebar baru
          ),
          padding: EdgeInsets.symmetric(horizontal: isIconOnly ? 0 : 16),
        ),
        child: isIconOnly
            ? Icon(icon, size: 20)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
