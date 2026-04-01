import 'package:get/get.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/models/product.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
var selectedPayment = 'cash'.obs; 
var inputUang = 0.0.obs;
  void addToCart(Product product) {
    var existingItem = cartItems.firstWhereOrNull(
      (item) => item.productId == product.id,
    );
    if (existingItem != null) {
      existingItem.qty++;
      cartItems.refresh();
    } else {
      cartItems.add(
        CartItem(
          productId: product.id,
          name: product.name,
          price: product.price,
          discount: product.discount,
          qty: 1,
          
          
        ),
      );
    }
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.productId == productId);
  }

  void increaseQty(int productId) {
    var item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null) {
      item.qty++;
      cartItems.refresh();
    }
  }

  void decreaseQty(int productId) {
    var item = cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null && item.qty > 1) {
      item.qty--;
      cartItems.refresh();
    }
  }
 void setInputUang(String value) {
    if (value.isEmpty) {
      inputUang.value = 0;
    } else {
      // Menghapus karakter non-numeric jika ada, lalu parse
      inputUang.value = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    }
  }
  void clearCart() {
    cartItems.clear(); 
    selectedPayment.value = 'cash';
    inputUang.value = 0.0; 
  }

  // 1. Menghitung Harga Total Akhir (Sudah termasuk potongan diskon)
  double get totalPrice {
    return cartItems.fold(0, (sum, item) {
      double hargaSetelahDiskon = item.price - item.discount;
      return sum + (hargaSetelahDiskon * item.qty);
    });
  }

  // 2. Menghitung Subtotal (Harga Asli tanpa diskon)
  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.qty));
  }
  double get kembalian {
    if (inputUang.value > totalPrice) {
      return inputUang.value - totalPrice;
    }
    return 0.0;
  }
  bool get isUangCukup => inputUang.value >= totalPrice && totalPrice > 0;

  // 3. Menghitung Total Nominal Diskon (Tanda penghematan)
  double get totalDiscount {
    return cartItems.fold(0, (sum, item) => sum + (item.discount * item.qty));
  }

  int get itemCount {
    return cartItems.length;
  }
}