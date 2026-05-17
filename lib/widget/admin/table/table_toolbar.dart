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
      width: isIconOnly ? 56 : null,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isIconOnly ? 100 : 16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isIconOnly
            ? Icon(icon)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [Icon(icon), const SizedBox(width: 8), Text(title!)],
              ),
      ),
    );
  }
}
