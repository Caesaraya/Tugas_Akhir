import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/admin/product_table_controller.dart';

class InsertProductDialog extends StatelessWidget {
  InsertProductDialog({super.key});

  final ctrl = Get.find<ProductTableController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Product'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                // Asumsi nama variabel di controllermu adalah `selectedImage`
                // dan tipenya adalah Rx<File?>
                if (ctrl.selectedImage.value != null) {
                  return Container(
                    height: 150,
                    width: 150,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        ctrl.selectedImage.value!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    height: 150,
                    width: 150,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Belum ada\ngambar',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
              }),

              // ===============================
              ElevatedButton(
                onPressed: ctrl.pickImage,
                child: const Text('Pilih Gambar'),
              ),
              TextField(
                controller: ctrl.nameC,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: ctrl.priceC,
                decoration: const InputDecoration(labelText: 'Harga'),
              ),
              TextField(
                controller: ctrl.discountC,
                decoration: const InputDecoration(labelText: 'Diskon'),
              ),
              TextField(
                controller: ctrl.stockC,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              TextField(
                controller: ctrl.jenisC,
                decoration: const InputDecoration(labelText: 'Jenis'),
              ),
              TextField(
                controller: ctrl.satuanC,
                decoration: const InputDecoration(labelText: 'Satuan'),
              ),

              const SizedBox(height: 20),

              // === TAMBAHAN PREVIEW GAMBAR ===
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Batal', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: ctrl.insertProduct,
          child: const Text('Insert'),
        ),
      ],
    );
  }
}
