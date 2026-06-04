import 'package:flutter/material.dart';

class DashboardGreeting extends StatelessWidget {
  const DashboardGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo Someone!  ',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Mau pesan apa hari ini?',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}
