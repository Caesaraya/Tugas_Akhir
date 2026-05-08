class Product {
  final int id;
  final String name;
  final int price;
  int discount;
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
      discount:int.tryParse(json['discount'].toString()) ?? 0,
      stock: int.tryParse(json['stock'].toString()) ?? 0,
      jenis: json['jenis'] ?? '',
      satuan: json['satuan'] ?? '',
      barcode: json['barcode'] ?? '',
      image: json['image'] ?? '',
      resepId:
          int.tryParse(json['resep_id'].toString()),
    );
  }
}
