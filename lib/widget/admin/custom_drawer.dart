import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/admin/navigation_controller.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final NavigationController navC = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(
        () => ListView(
          children: [
            const DrawerHeader(
              child: Text("My App 🚀", style: TextStyle(fontSize: 24)),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              selected: navC.selectedIndex.value == 0,
              onTap: () {
                navC.changePage(0);
                Get.back();
              },
            ),

            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text("Product"),
              selected: navC.selectedIndex.value == 1,
              onTap: () {
                navC.changePage(1);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
