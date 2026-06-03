import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/api service/api_service.dart';
import 'dart:typed_data';

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
  File? _selectedImage;
  final ImagePicker imagePicker = ImagePicker();
  bool _isImageLoading = false;
  Uint8List? _imageBytes;

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
    'piece',
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
    _requestPermissions();
  }

  void _initializeFields() {
    final product = widget.product!;
    _nameController.text = product.name;
    _priceController.text = product.price.toString();
    _discountController.text = product.discount.toString();
    _stockController.text = product.stock.toString();
    _satuanController.text = product.satuan;
    _selectedJenis = product.jenis;
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.storage,
    ].request();
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

  Future<void> _pickImage() async {
    try {
      setState(() {
        _isImageLoading = true;
      });
      
      final ImagePicker picker = ImagePicker();
      
      // Try to get image from gallery first
      XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Reduced quality for better performance
        maxWidth: 800, // Limit width for better performance
        maxHeight: 800, // Limit height for better performance
      );
      
      // If gallery fails or user cancels, try camera
      if (image == null) {
        image = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 70,
          maxWidth: 800,
          maxHeight: 800,
        );
      }
      
      if (image != null) {
        // Read image bytes in background
        final bytes = await image.readAsBytes();
        
        setState(() {
          _selectedImage = File(image!.path);
          _imageBytes = bytes;
          _isImageLoading = false;
        });
      } else {
        setState(() {
          _isImageLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final price = int.parse(_priceController.text);
      final discount = int.parse(_discountController.text);
      final stock = int.parse(_stockController.text);

      if (widget.product == null) {
        // Create new product
        if (_selectedImage == null) {
          Get.snackbar('Error', 'Silakan pilih gambar produk');
          setState(() => _isLoading = false);
          return;
        }

        await ApiService.createProductWithImage(
          name: _nameController.text,
          price: price,
          discount: discount,
          stock: stock,
          jenis: _selectedJenis,
          satuan: _satuanController.text,
          imageFile: _selectedImage!,
          resepId: widget.product?.resepId,
        );
        Get.snackbar('Sukses', 'Produk berhasil ditambahkan');
      } else {
        // Update existing product
        await ApiService.updateProductWithImage(
          id: widget.product!.id,
          name: _nameController.text,
          price: price,
          discount: discount,
          stock: stock,
          jenis: _selectedJenis,
          satuan: _satuanController.text,
          imageFile: _selectedImage,
          resepId: widget.product?.resepId,
        );
        Get.snackbar('Sukses', 'Produk berhasil diupdate');
      }

      Get.back(result: true);
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan produk: $e');
    } finally {
      setState(() => _isLoading = false);
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
              // Image Upload Section
              _buildImageUploadSection(),
              const SizedBox(height: 16),

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
                  border: OutlineInputBorder(),
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
                      value: _satuanController.text.isEmpty ? 'pcs' : 
                             _satuanOptions.contains(_satuanController.text) ? _satuanController.text : 'pcs',
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

  Widget _buildImageUploadSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.image, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Gambar Produk',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                if (_isImageLoading) ...[
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (_selectedImage != null) ...[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _imageBytes != null
                            ? Image.memory(
                                _imageBytes!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                gaplessPlayback: true, // Prevent flickering
                              )
                            : Image.file(
                                _selectedImage!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                              ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedImage = null;
                              _imageBytes = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.product != null && _selectedImage == null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.product!.image,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.image, color: Colors.grey[400]),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (_selectedImage == null && widget.product == null) ...[
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, 
                           size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text(
                          'Pilih Gambar',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt),
                    label: Text(_selectedImage != null || widget.product != null 
                        ? 'Ganti Gambar' 
                        : 'Pilih Gambar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
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
