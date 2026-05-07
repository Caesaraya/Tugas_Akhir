import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/models/cart_item.dart';

class ApiService {
  static const String baseUrl =
      "https://oafishly-noncontagious-cali.ngrok-free.dev";

  // ========================
  // COMMON HEADERS
  // ========================
  static Map<String, String> headers = {
    "Content-Type": "application/json",
    "Connection": "close",
  };

  // ========================
  // GET PRODUCTS
  // ========================
  static Future<List<Product>> getProducts() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/products"),
            headers: {
              "Connection": "close",
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);

        return data.map((e) => Product.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      throw Exception("Gagal memuat produk: $e");
    }
  }

  // ========================
  // UPDATE PRODUCT
  // ========================
  static Future<bool> updateProduct(Product product) async {
    try {
      final url = Uri.parse(
        "$baseUrl/api/products/${product.id}",
      );

      final body = {
        "name": product.name,
        "price": product.price,
        "discount": product.discount,
        "stock": product.stock,
        "jenis": product.jenis,
        "satuan": product.satuan,
        "barcode": product.barcode,
        "image": product.image,
      };

      final response = await http
          .put(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update produk: $e");
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
    try {
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

      final response = await http
          .post(
            url,
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal transaksi: $e");
    }
  }

  // ========================
  // GET TRANSACTIONS
  // ========================
  static Future<List<dynamic>> getTransactions() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/transactions"),
            headers: {
              "Connection": "close",
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load transactions");
      }
    } catch (e) {
      throw Exception("Gagal memuat transaksi: $e");
    }
  }

  // ========================
  // GET TRANSACTION DETAIL
  // ========================
  static Future<List<dynamic>> getTransactionDetail(
    int id,
  ) async {
    try {
      final response = await http
          .get(
            Uri.parse(
              "$baseUrl/api/transactions/$id",
            ),
            headers: {
              "Connection": "close",
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load detail");
      }
    } catch (e) {
      throw Exception("Gagal memuat detail: $e");
    }
  }
}