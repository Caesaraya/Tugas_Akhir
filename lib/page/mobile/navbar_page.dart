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
      ),
    );
  }
}
