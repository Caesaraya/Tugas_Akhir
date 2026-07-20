class CartItem {
  final int productId;
  final String name;
  final int price;   
  final int discount;
  final int stock; 
  int qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.discount,
    required this.stock,
    this.qty = 1,
  });

 
  double get total {
  double hargaAsli = price.toDouble();
  double hargaSetelahDiskon =
      (hargaAsli - (hargaAsli * (discount / 100))).roundToDouble();
  return hargaSetelahDiskon * qty;
  }
}