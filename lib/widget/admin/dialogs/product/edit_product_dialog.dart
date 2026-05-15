import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/admin/product_table_controller.dart';
import '../../../../models/product.dart';

class EditProductDialog extends StatelessWidget {
  final Product product;

  EditProductDialog({super.key, required this.product});

  final ctrl = Get.find<ProductTableController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
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

              // === PREVIEW GAMBAR LAMA / BARU ===
              Obx(() {
                // 1. Jika ada gambar baru yang dipilih dari galeri
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
                }
                // 2. Jika tidak ada gambar baru, tampilkan gambar lama dari server
                else if (ctrl.oldImageUrl.value.isNotEmpty) {
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
                      child: Image.network(
                        ctrl
                            .oldImageUrl
                            .value, // Pastikan menambahkan ApiService.baseUrl jika path-nya relative
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  );
                }
                // 3. Fallback jika tidak ada gambar sama sekali
                else {
                  return Container(
                    height: 150,
                    width: 150,
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(color: Colors.grey.shade400),
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

              ElevatedButton(
                onPressed: ctrl.pickImage,
                child: const Text('Ganti Gambar'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ctrl.clearForm();
            Get.back();
          },
          child: const Text('Batal', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () => ctrl.updateProductData(product),
          child: const Text('Update'),
        ),
      ],
    );
  }
}
