import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/controller/bakery_controller.dart';

class ManualBahanPage extends StatelessWidget {
  const ManualBahanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<BakeryController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFA),
      appBar: AppBar(
        title: const Text(
          'Pengambilan Manual',
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Pilih Bahan Baku',
                  labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                items: ctrl.bahanBakuList.map((b) {
                  return DropdownMenuItem<int>(
                    value: b.id,
                    child: Text(
                      '${b.namaBahan} (Stok: ${ctrl.formatQty(b.stok)} ${b.satuan})',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (id) {
                  if (id != null) {
                    final selected = ctrl.bahanBakuList.firstWhere(
                      (element) => element.id == id,
                    );
                    ctrl.tambahKeKeranjangManual(selected);
                  }
                },
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ctrl.manualCart.isEmpty
                  ? const Center(
                      child: Text(
                        'Keranjang kosong. Tambahkan bahan di atas.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: ctrl.manualCart.length,
                      itemBuilder: (context, index) {
                        final item = ctrl.manualCart[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.bahan.namaBahan,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Stok Tersedia: ${ctrl.formatQty(item.bahan.stok)} ${item.bahan.satuan}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 110,
                                child: TextFormField(
                                  initialValue: item.qtyAmbil.toString(),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    suffixText: item.bahan.satuan,
                                    suffixStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 4,
                                    ),
                                    isDense: true,
                                  ),
                                  onChanged: (val) {
                                    double? parsedValue = double.tryParse(val);
                                    if (parsedValue != null) {
                                      ctrl.updateQtyManualCart(
                                        index,
                                        parsedValue,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              color: Colors.white,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE89336),
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  disabledBackgroundColor: Colors.grey.shade300,
                  elevation: 0,
                ),
                onPressed: ctrl.manualCart.isEmpty || ctrl.isLoading.value
                    ? null
                    : () => ctrl.kirimPengambilanManual(),
                child: ctrl.isLoading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
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
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
