import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  // OPTIONAL
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final double borderRadius;
  final double fontSize;
  final bool isLoading;

  const ActionButton({
    super.key,

    required this.text,
    required this.onTap,

    // optional
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 50,
    this.borderRadius = 14,
    this.fontSize = 16,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,

        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.blue,

          foregroundColor: foregroundColor ?? Colors.white,

          elevation: 2,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),

        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),

                  const SizedBox(width: 8),

                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
