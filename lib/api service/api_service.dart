import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/models/cart_item.dart';

class ApiService {
  static const String baseUrl =
      "https://oafishly-noncontagious-cali.ngrok-free.dev";

  // ========================
  // GET PRODUCTS
  // ========================
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse("$baseUrl/api/products"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }

  // ========================
  // CREATE TRANSACTION
  // ========================
  static Future<bool> createTransaction({
    required double total,
    required double bayar,
    required double kembalian,
    required String metode,
    required List<CartItem> cart,
  }) async {
    final url = Uri.parse("$baseUrl/api/transactions");

    final body = {
      "total_harga": total,
      "metode_pembayaran": metode,
      "jumlah_bayar": bayar,
      "kembalian": kembalian,
      "items": cart
          .map(
            (item) => {
              "product_id": item.productId,
              "qty": item.qty,
              "price": item.price, 
              "subtotal": item.total,
            },
          )
          .toList(),
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  static Future<List<dynamic>> getTransactions() async {
    final response = await http.get(Uri.parse("$baseUrl/api/transactions"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load transactions");
    }
  }


  static Future<List<dynamic>> getTransactionDetail(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/api/transactions/$id"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load detail");
    }
  }
}