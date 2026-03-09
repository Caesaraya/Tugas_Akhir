class CartItem {

  final int productId;
  final String name;
  final double price;
  final double discount;

  int qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.discount,
    this.qty = 1,
  });

  double get total {

    double finalPrice = price - discount;

    return finalPrice * qty;

  }

}