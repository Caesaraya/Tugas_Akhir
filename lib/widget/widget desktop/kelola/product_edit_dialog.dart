import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/models/product.dart';

class ProductEditDialog extends StatefulWidget {
  final Product product;
  final Future<void> Function(Product) onSave;

  const ProductEditDialog({
    super.key,
    required this.product,
    required this.onSave,
  });

  @override
  State<ProductEditDialog> createState() => _ProductEditDialogState();
}

class _ProductEditDialogState extends State<ProductEditDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController discountController;
  late TextEditingController stockController;
  late TextEditingController jenisController;
  late TextEditingController satuanController;
  late TextEditingController barcodeController;
  late TextEditingController imageController;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    discountController = TextEditingController(
      text: widget.product.discount.toString(),
    );
    stockController = TextEditingController(
      text: widget.product.stock.toString(),
    );
    jenisController = TextEditingController(text: widget.product.jenis);
    satuanController = TextEditingController(text: widget.product.satuan);
    barcodeController = TextEditingController(text: widget.product.barcode);
    imageController = TextEditingController(text: widget.product.image);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    discountController.dispose();
    stockController.dispose();
    jenisController.dispose();
    satuanController.dispose();
    barcodeController.dispose();
    imageController.dispose();
    super.dispose();
  }

  // Future<void> _saveChanges() async {
  //   final updatedProduct = Product(
  //     id: widget.product.id,
  //     name: nameController.text,
  //     price: int.tryParse(priceController.text) ?? widget.product.price,
  //     discount:
  //         int.tryParse(discountController.text) ?? widget.product.discount,
  //     stock: int.tryParse(stockController.text) ?? widget.product.stock,
  //     jenis: jenisController.text,
  //     satuan: satuanController.text,
  //     barcode: barcodeController.text,
  //     image: imageController.text.trim().isEmpty
  //         ? widget.product.image
  //         : imageController.text.trim(),
  //   );

  //   setState(() => isSaving = true);
  //   await widget.onSave(updatedProduct);
  //   setState(() => isSaving = false);

  //   if (mounted) {
  //     Navigator.of(context).pop();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Produk'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Produk'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(labelText: 'Diskon (%)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: jenisController,
              decoration: const InputDecoration(labelText: 'Jenis'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: satuanController,
              decoration: const InputDecoration(labelText: 'Satuan'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: barcodeController,
              decoration: const InputDecoration(labelText: 'Barcode'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: imageController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        // ElevatedButton(
        //   onPressed: isSaving ? null : _saveChanges,
        //   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        //   child: isSaving
        //       ? const SizedBox(
        //           width: 20,
        //           height: 20,
        //           child: CircularProgressIndicator(strokeWidth: 2),
        //         )
        //       : const Text('Simpan'),
        // ),
      ],
    );
  }
}
