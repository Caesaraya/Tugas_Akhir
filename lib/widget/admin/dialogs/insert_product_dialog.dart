import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/admin/product_table_controller.dart';

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

              ElevatedButton(
                onPressed: ctrl.pickImage,
                child: const Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: ctrl.insertProduct,
          child: const Text('Insert'),
        ),
      ],
    );
  }
}
