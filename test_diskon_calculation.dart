// Test file untuk validasi perhitungan diskon yang sudah diperbaiki
// Contoh kasus:
// - Produk: Roti dengan harga asli Rp 10.000
// - Diskon: 30%
// - Quantity: 2
// 
// Perhitungan yang benar:
// - Harga setelah diskon per item: Rp 10.000 × (1 - 30/100) = Rp 7.000
// - Subtotal: Rp 7.000 × 2 = Rp 14.000
// - Total diskon: (Rp 10.000 × 30/100) × 2 = Rp 6.000
// - Total pembayaran: Rp 14.000

void main() {
  print('=== TEST PERHITUNGAN DISKON YANG SUDAH DIPERBAIKI ===');
  print('');
  
  // Contoh data dari backend (setelah perbaikan)
  final itemFromBackend = {
    'product_name': 'Roti Manis',
    'price': 10000.0,        // Harga ASLI dari backend
    'quantity': 2,
    'discount': 30.0,        // Diskon dalam PERSEN dari backend
    'subtotal': 14000.0,     // Sudah dihitung backend: (10000 × 0.7) × 2
  };
  
  // Test kalkulasi dengan logika baru
  final price = itemFromBackend['price'] as double;           // Harga asli
  final quantity = itemFromBackend['quantity'] as int;
  final discountPercent = itemFromBackend['discount'] as double;
  final subtotal = itemFromBackend['subtotal'] as double;
  
  // Hitung harga setelah diskon (untuk display)
  final priceAfterDiscount = discountPercent > 0 
    ? price * (1 - discountPercent / 100)
    : price;
  
  // Hitung total diskon
  final discountAmount = (price * discountPercent / 100) * quantity;
  
  print('DATA DARI BACKEND:');
  print('- Harga asli: Rp ${price.toStringAsFixed(0)}');
  print('- Diskon: $discountPercent%');
  print('- Quantity: $quantity');
  print('- Subtotal (dari backend): Rp ${subtotal.toStringAsFixed(0)}');
  print('');
  
  print('PERHITUNGAN FRONTEND:');
  print('- Harga setelah diskon: Rp ${priceAfterDiscount.toStringAsFixed(0)}');
  print('- Subtotal: Rp ${(priceAfterDiscount * quantity).toStringAsFixed(0)}');
  print('- Total diskon: Rp ${discountAmount.toStringAsFixed(0)}');
  print('- Total pembayaran: Rp ${subtotal.toStringAsFixed(0)}');
  print('');
  
  print('VALIDASI:');
  print('✅ Subtotal backend == Subtotal frontend: ${subtotal == (priceAfterDiscount * quantity)}');
  print('✅ Total diskon: Rp ${discountAmount.toStringAsFixed(0)}');
  print('✅ Total pembayaran: Rp ${subtotal.toStringAsFixed(0)}');
  print('');
  
  print('EXPECTED RESULT:');
  print('- Harga asli: Rp 10.000');
  print('- Diskon: 30%');
  print('- Harga setelah diskon: Rp 7.000');
  print('- Subtotal: Rp 14.000');
  print('- Total diskon: Rp 6.000');
  print('- Total pembayaran: Rp 14.000');
  
  // Test CartItem calculation
  print('');
  print('=== TEST CARTITEM MODEL ===');
  final cartItem = CartItem(
    productId: 1,
    name: 'Roti Manis',
    price: 10000,
    discount: 30,  // persen
    qty: 2,
  );
  
  print('CartItem.total: Rp ${cartItem.total.toStringAsFixed(0)}');
  print('Expected: Rp 14.000');
  print('✅ CartItem calculation correct: ${cartItem.total == 14000}');
}

class CartItem {
  final int productId;
  final String name;
  final int price;    // Harga asli
  final int discount; // Diskon dalam persen
  int qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.discount,
    this.qty = 1,
  });

  double get total {
    double finalPrice = discount > 0 
      ? price * (1 - discount / 100)  // Hitung harga setelah diskon persen
      : price.toDouble();
    return finalPrice * qty;
  }
}
