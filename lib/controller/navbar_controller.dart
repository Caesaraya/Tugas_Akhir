import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/page/mobile/Kasir_dashboard_mobile.dart';
import 'package:tugas_akhir/page/mobile/keranjang_mobile.dart';

class NavbarController extends GetxController {
  var currentIndex = 0.obs;

  final List<Widget> pages = [KasirDashboardMobile(), KeranjangMobilePage()];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
