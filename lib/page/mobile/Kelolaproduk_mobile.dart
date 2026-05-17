import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/kelola_controller.dart';
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';
import 'package:tugas_akhir/widget/widget desktop/kelola/kelola_produk_list.dart';
import 'package:tugas_akhir/widget/widget desktop/kelola/kelola_produk_search_bar.dart';
 
class KelolaProdukPage extends StatelessWidget {
  const KelolaProdukPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    final KelolaProdukController kelolaProdukController = Get.put(KelolaProdukController());
 
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
       drawer: const KasirMobileDrawer(),
      appBar: AppBar(
        title: const Text(
          'Kelola Produk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE89336),
        centerTitle: true,
        elevation: 0,
            leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: kelolaProdukController.fetchData,
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          KelolaProdukSearchBar(ctrl: kelolaProdukController),
          Expanded(child: KelolaProdukList(ctrl: kelolaProdukController)),
        ],
      ),
    );
  }
}