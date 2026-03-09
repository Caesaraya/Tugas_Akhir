class Product {

  final int id;
  final String name;
  final double price;
  final double discount;
  final int stock;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.stock,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
      id: json["id"],
      name: json["name"],
      price: double.parse(json["price"].toString()),
      discount: double.parse(json["discount"].toString()),
      stock: json["stock"],
      image: json["image"],
    );

  }
}