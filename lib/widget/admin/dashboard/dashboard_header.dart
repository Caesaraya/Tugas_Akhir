import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir/utils/app_color.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id');
    const secondaryTextColor = Color(0xFF6B7280);
    const borderColor = Color(0xFFE5E7EB);

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dateFormat.format(DateTime.now()),
              style: const TextStyle(color: secondaryTextColor, fontSize: 14),
            ),
          ],
        ),
        // User Profile
        // Row(
        //   children: [
        //     CircleAvatar(
        //       backgroundColor: AppColors.black,
        //       radius: 18,
        //       child: const Text(
        //         'A',
        //         style: TextStyle(
        //           color: AppColors.white,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //     const Text(
        //       'Admin Bakery',
        //       style: TextStyle(
        //         fontWeight: FontWeight.w500,
        //         color: AppColors.black,
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
