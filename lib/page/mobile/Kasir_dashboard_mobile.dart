import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_Mobile_controller.dart';
import 'package:tugas_akhir/widget/widget mobile/search_bar.dart';
import 'package:tugas_akhir/widget/widget mobile/section_header.dart';
import 'package:tugas_akhir/widget/widget mobile/product_list.dart';

class KasirDashboardMobile extends StatelessWidget {
  KasirDashboardMobile({super.key});
  final DashboardController controller = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.fetchProducts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Image.asset(
                      'assets/Logo_Rumah_Lezaa-removebg-preview.png',
                      height: 150, // Ukuran proporsional
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const Text(
                  "Halo, Someone!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Mau pesan roti apa hari ini?",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 20),
                MySearchBar(
                  onChanged: (value) {
                    // Panggil fungsi filter setiap kali pengguna mengetik
                    controller.filterProducts(value);
                  },
                ),
                const SizedBox(height: 30),
                SectionHeader(title: "Rekomendasi Terlaris"),
                // 5. Product List (Horizontal)
                ProductList(
                  limit: 5,
                  tagBuilder: (index) => index == 0 ? "Hot Item" : "New",
                ),
                const SizedBox(height: 30),
                SectionHeader(title: "Produk Terbaru"),
                ProductList(tagBuilder: (index) => "New"),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}