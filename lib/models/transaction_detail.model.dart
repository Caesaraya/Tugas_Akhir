class TransactionDetailModel {
  final int id;
  final int productId;
  final String name;
  final String jenis;
  final String satuan;
  final String image;
  final int quantity;
  final double price;
  final double subtotal;
  final double discount;

  TransactionDetailModel({
    required this.id,
    required this.productId,
    required this.name,
    required this.jenis,
    required this.satuan,
    required this.image,
    required this.quantity,
    required this.price,
    required this.subtotal,
    required this.discount,
  });

  factory TransactionDetailModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionDetailModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      name: json['product_name'] ?? '',
      jenis: json['product_jenis'] ?? '',
      satuan: json['product_satuan'] ?? '',
      // Backend menyediakan image URL lengkap di field 'image'
      // Fallback ke 'product_image' untuk backward compatibility
      image: json['image'] ?? json['product_image'] ?? '',
      quantity: json['quantity'] ?? json['qty'] ?? 0,
      price:
          double.tryParse(json['price'].toString()) ?? 0,
      subtotal:
          double.tryParse(json['subtotal'].toString()) ?? 0,
      discount:
          double.tryParse(json['discount'].toString()) ?? 0,
    );
  }
}