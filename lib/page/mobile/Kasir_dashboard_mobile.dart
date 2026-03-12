import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/dashboard_Mobile_controller.dart';
import '../../widget/search_bar.dart';
import '../../widget/section_header.dart';
import '../../widget/product_list.dart';

class KasirDashboardMobile extends StatelessWidget {
  // Gunakan Get.find jika controller sudah di-put di level main/binding,
  // atau Get.put jika ini entry point pertama.

  KasirDashboardMobile({super.key});
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      // Body tidak lagi menggunakan Stack/NavbarPage di dalamnya
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => controller.fetchProducts(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Logo Header
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

                // 2. Greeting Section
                const Text(
                  "Halo, Someone!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Mau pesan roti apa hari ini?",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),

                const SizedBox(height: 20),

                // 3. Search Bar Widget
                MySearchBar(
                  onChanged: (value) {
                    // Panggil fungsi filter setiap kali pengguna mengetik
                    controller.filterProducts(value);
                  },
                ),

                const SizedBox(height: 30),

                // 4. Section Header
                SectionHeader(title: "Rekomendasi Terlaris"),

                // 5. Product List (Horizontal)
                ProductList(
                  tagBuilder: (index) => index == 0 ? "Hot Item" : "New",
                ),

                const SizedBox(height: 30),

                SectionHeader(title: "Produk Terbaru"),

                ProductList(tagBuilder: (index) => "New"),

                // Tambahkan SizedBox di paling bawah agar tidak terlalu mepet dengan Navbar
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
