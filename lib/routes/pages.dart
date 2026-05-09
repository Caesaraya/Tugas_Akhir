import 'package:get/get.dart';
import 'package:tugas_akhir/pages/main_page.dart';
import 'package:tugas_akhir/pages/products/product_list_page.dart';
import 'package:tugas_akhir/pages/products/product_detail_page.dart';
import 'package:tugas_akhir/pages/products/product_form_page.dart';
import 'package:tugas_akhir/pages/riwayat_transaksi_page.dart';
import 'package:tugas_akhir/pages/detail_transaksi_page.dart';
import 'routes.dart';

class AppPages {
  static final pages = [
    //main entry point
    GetPage(name: AppRoutes.main, page: () => const MainPage()),
    //main pages
    GetPage(name: AppRoutes.productList, page: () => ProductListPage()),
    GetPage(name: AppRoutes.riwayatTransaksi, page: () => RiwayatTransaksiPage()),
    GetPage(
      name: AppRoutes.detailTransaksi,
      page: () => DetailTransaksiPage(transaction: Get.arguments),
    ),
    //products management
    GetPage(
      name: AppRoutes.productDetail,
      page: () => ProductDetailPage(productId: Get.arguments),
    ),
    GetPage(name: AppRoutes.productCreate, page: () => ProductFormPage()),
    GetPage(
      name: AppRoutes.productEdit,
      page: () => ProductFormPage(product: Get.arguments),
    ),
  ];
}
