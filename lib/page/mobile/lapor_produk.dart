import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/lapor_produk_controller.dart';
import 'package:tugas_akhir/page/mobile/drawer_mobile.dart';
import 'package:tugas_akhir/page/mobile/laporan_riwayat_page.dart';
import 'package:tugas_akhir/widget/widget mobile/lapor/lapor_list.dart';
import 'package:tugas_akhir/widget/widget mobile/lapor/search_bar.dart';

class LaporProdukPage extends StatelessWidget {
  const LaporProdukPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LaporProdukController laporProdukController = Get.put(
      LaporProdukController(),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      drawer: const KasirMobileDrawer(),

      appBar: AppBar(
        title: const Text(
          'Lapor Produk',
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
            tooltip: 'Riwayat Laporan',
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {
              Get.to(() => const LaporanRiwayatPage());
            },
          ),
        ],
      ),

      body: Column(
        children: [
          LaporProdukSearchBar(ctrl: laporProdukController),

          Expanded(child: LaporProdukList(ctrl: laporProdukController)),
        ],
      ),
    );
  }
}
