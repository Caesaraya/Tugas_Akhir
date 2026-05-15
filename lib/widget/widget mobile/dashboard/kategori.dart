import 'package:flutter/material.dart';
import 'package:tugas_akhir/controller/dashboard_controller.dart';

class DashboardCategoryTabs extends StatelessWidget {
  final DashboardController ctrl;
 
  const DashboardCategoryTabs({super.key, required this.ctrl});
 
  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorColor: Colors.orange,
      labelColor: Colors.orange,
      unselectedLabelColor: Colors.grey,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      onTap: (index) => ctrl.applyFilter(category: ctrl.categories[index]),
      tabs: ctrl.categories
          .map((jenis) => Tab(text: jenis.toUpperCase()))
          .toList(),
    );
  }
}