import 'dart:io';

class Product {
  final int id;
  final String name;
  final int price;
  final int discount;
  final int priceAfterDiscount; // Field baru
  final int stock;
  final String jenis;
  final String satuan;
  final String barcode;
  final String image;
  final int? resepId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.priceAfterDiscount, // Tambahkan di constructor
    required this.stock,
    required this.jenis,
    required this.satuan,
    required this.barcode,
    required this.image,
    this.resepId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      discount: int.tryParse(json['discount'].toString()) ?? 0,
      // Ambil data dari field baru di API
      priceAfterDiscount: int.tryParse(json['price_after_discount'].toString()) ?? 0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      jenis: json['jenis'] ?? '',
      satuan: json['satuan'] ?? '',
      barcode: json['barcode'] ?? '',
      image: json['image'] ?? '',
      resepId: int.tryParse(json['resep_id'].toString()),
    );
  }

  // Method untuk copyWith
  Product copyWith({
    int? id,
    String? name,
    int? price,
    int? discount,
    int? priceAfterDiscount,
    int? stock,
    String? jenis,
    String? satuan,
    String? barcode,
    String? image,
    int? resepId,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      stock: stock ?? this.stock,
      jenis: jenis ?? this.jenis,
      satuan: satuan ?? this.satuan,
      barcode: barcode ?? this.barcode,
      image: image ?? this.image,
      resepId: resepId ?? this.resepId,
    );
  }

  // Method untuk convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'discount': discount,
      'price_after_discount': priceAfterDiscount,
      'stock': stock,
      'jenis': jenis,
      'satuan': satuan,
      'barcode': barcode,
      'image': image,
      'resep_id': resepId,
    };
  }
}