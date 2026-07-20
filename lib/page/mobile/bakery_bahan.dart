import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';

class ManualBahanPage extends StatelessWidget {
  const ManualBahanPage({super.key});

  void tampilkanPopupInputQty(
    BuildContext context,
    BakeryController ctrl,
    BahanBaku bahan,
  ) {
    final qtyInputController = TextEditingController(text: "1.0");

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ambil ${bahan.namaBahan}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stok Tersedia: ${ctrl.formatQty(bahan.stok)} ${bahan.satuan}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: qtyInputController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Jumlah Pengambilan',
                suffixText: bahan.satuan,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE89336),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              double? qty = double.tryParse(qtyInputController.text);
              if (qty == null || qty <= 0) {
                Get.snackbar(
                  'Input Salah',
                  'Jumlah pengambilan harus lebih dari 0',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }
              if (qty > bahan.stok) {
                Get.snackbar(
                  'Stok Kurang',
                  'Jumlah pengambilan melebihi sisa stok gudang!',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
                return;
              }
              ctrl.tambahKeKeranjangManualDenganQty(bahan, qty);
              Get.back();
            },
            child: const Text(
              'Masukkan Keranjang',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void tampilkanBottomSheetKeranjang(
    BuildContext context,
    BakeryController ctrl,
  ) {
    Get.bottomSheet(
      Obx(() {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Keranjang Pengambilan (${ctrl.manualCart.length} Item)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              Flexible(
                child: ctrl.manualCart.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                          child: Text(
                            'Keranjang kosong',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: ctrl.manualCart.length,
                        itemBuilder: (context, index) {
                          final item = ctrl.manualCart[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              item.bahan.namaBahan,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              'Stok: ${ctrl.formatQty(item.bahan.stok)} ${item.bahan.satuan}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${ctrl.formatQty(item.qtyAmbil)} ${item.bahan.satuan}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE89336),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () =>
                                      ctrl.manualCart.removeAt(index),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89336),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: 0,
                ),
                onPressed: ctrl.manualCart.isEmpty || ctrl.isLoading.value
                    ? null
                    : () => ctrl.kirimPengambilanManual(),
                child: ctrl.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Konfirmasi Pengambilan Manual',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BakeryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      appBar: AppBar(
        title: const Text(
          'List Bahan Baku',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.bahanBakuList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.bahanBakuList.isEmpty) {
          return const Center(
            child: Text(
              'Tidak ada data bahan baku.',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ctrl.bahanBakuList.length,
          itemBuilder: (context, index) {
            final bahan = ctrl.bahanBakuList[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: Color(0xFFE89336),
                  ),
                ),
                title: Text(
                  bahan.namaBahan,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  'Merk: ${bahan.merk.isEmpty ? "-" : bahan.merk}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Sisa Stok',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      '${ctrl.formatQty(bahan.stok)} ${bahan.satuan}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: bahan.stok <= 0 ? Colors.red : Colors.black87,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  if (bahan.stok <= 0) {
                    Get.snackbar(
                      'Stok Habis',
                      'Bahan baku ini tidak bisa diambil karena stok kosong',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  tampilkanPopupInputQty(context, ctrl, bahan);
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: Obx(() {
        if (ctrl.manualCart.isEmpty)
          return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => tampilkanBottomSheetKeranjang(context, ctrl),
          backgroundColor: const Color(0xFFE89336),
          icon: Badge(
            label: Text(
              ctrl.manualCart.length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            child: const Icon(
              Icons.shopping_basket_outlined,
              color: Colors.white,
            ),
          ),
          label: const Text(
            'Lihat Keranjang',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }
}
