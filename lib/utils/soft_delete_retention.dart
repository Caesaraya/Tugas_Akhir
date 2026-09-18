import 'package:flutter/material.dart';

const Duration softDeleteRetention = Duration(days: 30);

class SoftDeleteRetentionInfo extends StatelessWidget {
  final Object? deletedAt;

  const SoftDeleteRetentionInfo({super.key, required this.deletedAt});

  String get label {
    final deletedDate = _parseDate(deletedAt);
    if (deletedDate == null) {
      return 'N/A';
    }

    final automaticDeletionDate = deletedDate.add(softDeleteRetention);
    final remaining = automaticDeletionDate.difference(DateTime.now());
    if (remaining <= Duration.zero) {
      return 'AUTO';
    }

    final days = remaining.inDays;
    if (days >= 1) {
      return '${days}H';
    }
    return '<1H';
  }

  @override
  Widget build(BuildContext context) {
    if (_parseDate(deletedAt) == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: TextStyle(
          color: Colors.orange.shade800,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

DateTime? _parseDate(Object? value) {
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}
