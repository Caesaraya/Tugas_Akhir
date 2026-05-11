import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/mobile/dashboard_Mobile_controller.dart';
import '../../controller/mobile/cart_controller.dart';
import '../../widget/widget desktop/dashboard/product_list_desktop.dart';
import '../../widget/widget desktop/dashboard/app_bar_desktop.dart';
import '../../widget/widget desktop/dashboard/cart_panel_desktop.dart';
import '../../widget/widget desktop/dashboard/desktop_navigation_drawer.dart';
import '../../routes/routes.dart';

class KasirDashboardDesktop extends StatelessWidget {
  KasirDashboardDesktop({super.key});

  // Memanggil controller yang sudah ada
  final DashboardController controller = Get.put(DashboardController());
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 1. Tampilkan loading jika data kategori belum dimuat
      if (controller.categories.isEmpty) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: Colors.orange)),
        );
      }

      // 2. DefaultTabController menggunakan jumlah kategori dinamis dari API
      return DefaultTabController(
        length: controller.categories.length,
        child: Scaffold(
          // Gunakan drawer desktop yang sudah kamu buat
          drawer: const DesktopNavigationDrawer(
            currentRoute: AppRoutes.kasirboarddesk,
          ),
          body: Row(
            children: [
              /// PANEL PRODUK (Kiri)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    /// APPBAR (Dengan fitur Search)
                    const AppBarDesktop(
                      title: "Rumah Lezzaaa - POS",
                      showSearch: true,
                    ),

                    /// TAB KATEGORI (Dinamis dari API jenis)
                    Container(
                      color: Colors.grey[100],
                      width: double.infinity,
                      child: TabBar(
                        isScrollable: true, // Agar jenis yang panjang (seperti GROSIR RESILEDO) tidak terpotong
                        onTap: (index) {
                          // Memfilter produk berdasarkan kategori yang dipilih
                          controller.applyFilter(
                            category: controller.categories[index],
                          );
                        },
                        labelColor: Colors.orange,
                        unselectedLabelColor: Colors.black54,
                        indicatorColor: Colors.orange,
                        indicatorWeight: 3,
                        // Mengubah List<String> categories menjadi List<Tab>
                        tabs: controller.categories.map((namaKategori) {
                          return Tab(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                namaKategori.toUpperCase(),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    /// LIST PRODUK (Dinamis berdasarkan tab/search)
                    Expanded(
                      child: ProductListDesktop(
                        // Tag statis atau bisa kamu kembangkan lagi nantinya
                        onProductTap: (product) {
                          // Menambahkan produk ke keranjang
                          cartController.addToCart(product);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              /// PANEL KERANJANG (Kanan)
              const CartPanelDesktop(),
            ],
          ),
        ),
      );
    });
  }
}