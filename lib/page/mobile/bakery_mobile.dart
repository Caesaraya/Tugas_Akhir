import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';
import 'package:tugas_akhir/controller/login_controller.dart';
import 'package:tugas_akhir/page/mobile/drawer_bakery.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard_bakery/grid.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard_bakery/search_bar.dart';

class BakeryPage extends StatelessWidget {
  const BakeryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(BakeryController());
    final loginController = Get.find<LoginController>();

    return Scaffold(
      drawer: const DrawerBakery(),
      backgroundColor: const Color(0xFFFDFBFA),
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ctrl.fetchResep,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final userName =
                      loginController.currentUser.value?.name ?? 'Bakery';
                  return Text(
                    'Halo, $userName',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }),
                const Text(
                  'Pilih resep untuk mulai produksi',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                BakerySearchBar(
                  onChanged: (val) => ctrl.searchQuery.value = val,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Daftar Resep',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                BakeryResepGrid(ctrl: ctrl),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
