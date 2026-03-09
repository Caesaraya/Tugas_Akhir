import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/dashboard_Mobile_controller.dart';
import 'package:tugas_akhir/widget/product_card.dart';
import 'package:tugas_akhir/widget/floating.dart';// Import navbar buatan kita

class DashboardMobilePage extends StatelessWidget {
  // Inisialisasi Controller
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA), // Warna background lebih soft
      body: Stack( // Gunakan Stack agar Navbar bisa melayang di atas konten
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100), // Padding bawah ekstra agar tak tertutup navbar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo Header
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset('assets/Logo_Rumah_Lezaa.jpg', height: 60),
                    ),
                  ),
                  
                  const Text("Halo, Maria!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Mau pesan apa hari ini?", style: TextStyle(color: Colors.grey)),
                  
                  const SizedBox(height: 20),
                  
                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Cari roti favoritmu...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  _sectionHeader("Rekomendasi"),
                  
                  // Menampilkan Data API dengan Obx
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.productList.isEmpty) {
                      return const Center(child: Text("Produk tidak ditemukan"));
                    }

                    return SizedBox(
                      height: 250, 
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.productList.length,
                        itemBuilder: (context, index) {
                          // Memasukkan data model ke ProductCard
                          return ProductCard(
                            product: controller.productList[index],
                            tag: index == 0 ? "Hot" : "New",
                          );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Memanggil Floating Navbar Modern
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => FloatingNavbar(
              selectedIndex: controller.selectedIndex.value,
              onTap: (index) => controller.selectedIndex.value = index,
            )),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Lihat Semua", style: TextStyle(color: Colors.brown[600], fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}