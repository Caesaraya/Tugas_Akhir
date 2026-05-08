class CartItem {
  final int productId;
  final String name;
  final int price;   
  final int discount;
  int qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.discount,
    this.qty = 1,
  });

 
  double get total {
    double finalPrice = (price - discount).toDouble();
    return finalPrice * qty;
  }
}