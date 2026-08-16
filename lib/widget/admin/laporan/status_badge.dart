import 'package:flutter/material.dart';

class LaporanStatusBadge extends StatelessWidget {
  final String status;

  const LaporanStatusBadge({super.key, required this.status});

  Color get _bgColor {
    switch (status) {
      case 'approved':
        return const Color(0xFFE8F5E9);
      case 'rejected':
        return const Color(0xFFFFEBEE);
      default:
        return const Color(0xFFFFF8E1);
    }
  }

  Color get _textColor {
    switch (status) {
      case 'approved':
        return const Color(0xFF2E7D32);
      case 'rejected':
        return const Color(0xFFC62828);
      default:
        return const Color(0xFFF57F17);
    }
  }

  String get _label {
    switch (status) {
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Menunggu';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: _textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
