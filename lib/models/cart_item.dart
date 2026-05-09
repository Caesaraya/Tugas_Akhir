class CartItem {
  final int productId;
  final String name;
  final int price;    // Ubah jadi int
  final int discount; // Ubah jadi int
  int qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.discount,
    this.qty = 1,
  });

  // Karena ini getter untuk total uang, return double tidak apa-apa
  double get total {
    double finalPrice = discount > 0 
      ? price * (1 - discount / 100)  // Hitung harga setelah diskon persen
      : price.toDouble();
    return finalPrice * qty;
  }
}