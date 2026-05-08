class TransactionDetailModel {
  final int id;
  final int productId;
  final String name;
  final int quantity;
  final double price;
  final double subtotal;
  final double discount;

  TransactionDetailModel({
    required this.id,
    required this.productId,
    required this.name,
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
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price:
          double.tryParse(json['price'].toString()) ?? 0,
      subtotal:
          double.tryParse(json['subtotal'].toString()) ??
              0,
      discount:
          double.tryParse(json['discount'].toString()) ??
              0,
    );
  }
}