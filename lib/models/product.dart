class Product {
  final int id;
  final String name;
  final int price;
  final int discount;
  final int stock;
  final String jenis;
  final String satuan;
  final String barcode;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.stock,
    required this.jenis,
    required this.satuan,
    required this.barcode,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      stock: json['stock'] ?? 0,
      jenis: json['jenis'] ?? '',
      satuan: json['satuan'] ?? '',
      barcode: json['barcode'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
