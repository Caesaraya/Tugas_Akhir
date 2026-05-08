import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/api service/api_service.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({Key? key, this.product}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _stockController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _satuanController = TextEditingController();

  String _selectedJenis = 'CAKE';
  bool _isLoading = false;

  final List<String> _jenisOptions = [
    'CAKE',
    'BREAD',
    'PASTA',
    'KUE KERING',
    'KONSINYASI',
    'MINUMAN',
    'TART',
    'PASTRY',
    'BASAHAN',
    'HANTARAN',
    'PACKAGING',
    'PUTUS',
    'GROSIR RESILEDO',
  ];

  final List<String> _satuanOptions = [
    'pcs',
    'kg',
    'liter',
    'box',
    'pack',
    'botol',
    'bungkus',
    'dus',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _initializeFields();
    }
  }

  void _initializeFields() {
    final product = widget.product!;
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _discountController.text = product.discount.toString();
    _stockController.text = product.stock.toString();
    _barcodeController.text = product.barcode;
    _satuanController.text = product.satuan;
    _selectedJenis = product.jenis;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    _barcodeController.dispose();
    _satuanController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final price = int.parse(_priceController.text);
      final discount = int.parse(_discountController.text);
      final stock = int.parse(_stockController.text);
      final priceAfterDiscount = price - (price * discount ~/ 100);

      final product = Product(
        id: widget.product?.id ?? 0,
        name: _nameController.text,
        price: price,
        discount: discount,
        priceAfterDiscount: priceAfterDiscount,
        stock: stock,
        jenis: _selectedJenis,
        satuan: _satuanController.text,
        barcode: _barcodeController.text,
        image: _getImageByJenis(_selectedJenis),
        resepId: widget.product?.resepId,
      );

      if (widget.product == null) {
        await ApiService.createProduct(product);
        Get.snackbar('Sukses', 'Produk berhasil ditambahkan');
      } else {
        await ApiService.updateProduct(product);
        Get.snackbar('Sukses', 'Produk berhasil diupdate');
      }

      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan produk: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getImageByJenis(String jenis) {
    switch (jenis) {
      case "CAKE":
        return "cake.jpg";
      case "BREAD":
        return "bread.jpg";
      case "PASTA":
        return "pasta.jpg";
      case "KUE KERING":
        return "kue_kering.jpg";
      case "KONSINYASI":
        return "konsinyasi.jpg";
      case "MINUMAN":
        return "minuman.jpg";
      case "TART":
        return "tart.jpg";
      case "PASTRY":
        return "pastry.jpg";
      case "BASAHAN":
        return "basahan.jpg";
      case "HANTARAN":
        return "hantaran.jpg";
      case "PACKAGING":
        return "packaging.jpg";
      case "PUTUS":
        return "putus.jpg";
      case "GROSIR RESILEDO":
        return "grosir.jpg";
      default:
        return "default.jpg";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Tambah Produk' : 'Edit Produk'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama produk tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Jenis Field
              DropdownButtonFormField<String>(
                value: _selectedJenis,
                decoration: const InputDecoration(
                  labelText: 'Jenis Produk',
                  border: OutlineInputBorder(),
                ),
                items: _jenisOptions.map((jenis) {
                  return DropdownMenuItem(
                    value: jenis,
                    child: Text(jenis),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedJenis = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Price Fields Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Harga',
                        border: OutlineInputBorder(),
                        prefixText: 'Rp ',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Harga harus angka';
                        }
                        return null;
                      },
                      onChanged: (value) => _updatePriceAfterDiscount(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _discountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Diskon (%)',
                        border: OutlineInputBorder(),
                        suffixText: '%',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Diskon tidak boleh kosong';
                        }
                        final discount = int.tryParse(value);
                        if (discount == null || discount < 0 || discount > 100) {
                          return 'Diskon 0-100';
                        }
                        return null;
                      },
                      onChanged: (value) => _updatePriceAfterDiscount(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Price After Discount (Read-only)
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Harga Setelah Diskon',
                  border: const OutlineInputBorder(),
                  prefixText: 'Rp ',
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
                controller: TextEditingController(
                  text: _calculatePriceAfterDiscount().toString(),
                ),
              ),
              const SizedBox(height: 16),

              // Stock and Satuan Row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Stok harus angka';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _satuanController.text.isEmpty ? 'pcs' : _satuanController.text,
                      decoration: const InputDecoration(
                        labelText: 'Satuan',
                        border: OutlineInputBorder(),
                      ),
                      items: _satuanOptions.map((satuan) {
                        return DropdownMenuItem(
                          value: satuan,
                          child: Text(satuan),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _satuanController.text = value!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Barcode Field
              TextFormField(
                controller: _barcodeController,
                decoration: const InputDecoration(
                  labelText: 'Barcode',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Barcode tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.product == null ? 'Tambah Produk' : 'Update Produk'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculatePriceAfterDiscount() {
    final price = int.tryParse(_priceController.text) ?? 0;
    final discount = int.tryParse(_discountController.text) ?? 0;
    return price - (price * discount ~/ 100);
  }

  void _updatePriceAfterDiscount() {
    setState(() {});
  }
}
