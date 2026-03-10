import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/page/dashboard_mobile.dart';
import 'package:tugas_akhir/page/keranjang_mobile.dart';


class NavbarController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [
    DashboardMobilePage(),
    KeranjangMobilePage() 
    ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
