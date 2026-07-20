import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';
import 'package:tugas_akhir/models/resep.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard_bakery/bahan_list.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard_bakery/button.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard_bakery/counter.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard_bakery/header_detail.dart';
import 'package:tugas_akhir/widget/widget mobile/dashboard_bakery/stat.dart';

class BakeryDetailPage extends StatelessWidget {
  final Resep resep;
  const BakeryDetailPage({super.key, required this.resep});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BakeryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black87),
                flexibleSpace: FlexibleSpaceBar(
                  background: BakeryHeaderDetail(resep: resep),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BakeryStatsRow(jumlahBahan: resep.bahan?.length ?? 0),
                      const SizedBox(height: 24),
                      BakeryBahanCounter(ctrl: ctrl, resep: resep),
                      const SizedBox(height: 14),
                      BakeryBahanList(ctrl: ctrl, resep: resep),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BakeryEstimasiButton(ctrl: ctrl, resep: resep),
          ),
        ],
      ),
    );
  }
}
