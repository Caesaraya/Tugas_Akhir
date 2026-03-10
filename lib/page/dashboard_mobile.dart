import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dashboard_Mobile_controller.dart';
import '../widget/product_card.dart';
import '../widget/search_bar.dart';

class DashboardMobilePage extends StatelessWidget {
  // Gunakan Get.find jika controller sudah di-put di level main/binding, 
  // atau Get.put jika ini entry point pertama.
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
                  "Halo, Amba!",
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
                    // Logika filter bisa ditaruh di controller
                    print("Mencari: $value");
                  },
                ),

                const SizedBox(height: 30),

                // 4. Section Header
                _sectionHeader("Rekomendasi Terlaris"),

                // 5. Product List (Horizontal)
                Obx(() {
                  if (controller.isLoading.value) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator(color: Colors.brown)),
                    );
                  }

                  if (controller.productList.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: Text("Produk sedang kosong")),
                    );
                  }

                  return SizedBox(
                    height: 260, // Sesuaikan dengan tinggi ProductCard kamu
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.productList.length,
                      clipBehavior: Clip.none, // Agar shadow kartu tidak terpotong
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: controller.productList[index],
                          tag: index == 0 ? "Hot Item" : "New",
                        );
                      },
                    ),
                  );
                }),
                
                // Tambahkan SizedBox di paling bawah agar tidak terlalu mepet dengan Navbar
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D1B1B)),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "Lihat Semua",
              style: TextStyle(color: Colors.brown[600], fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}