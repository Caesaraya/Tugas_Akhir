import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/navbar_controller.dart';

class NavbarPage extends StatelessWidget {
  NavbarPage({super.key});
  final NavbarController navbarController = Get.put(NavbarController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: navbarController.pages[navbarController.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: navbarController.currentIndex.value,
          onTap: (index) => navbarController.changePage(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Keranjang",
            ),
          ],
        ),
      ),
    );
  }
}