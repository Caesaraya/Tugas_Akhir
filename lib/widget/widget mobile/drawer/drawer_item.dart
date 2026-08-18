import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const DrawerItem({
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = Get.currentRoute == route;

    return ListTile(
      leading: Icon(
        icon,
        color: selected ? const Color(0xFFE89336) : Colors.black54,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? const Color(0xFFE89336) : Colors.black87,
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
      selected: selected,
      selectedTileColor: const Color(0xFFE89336).withOpacity(0.12),
      onTap: () {
        Navigator.pop(context);
        if (!selected) Get.offAllNamed(route);
      },
    );
  }
}
