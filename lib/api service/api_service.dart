import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

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
  // UPDATE PRODUCT
  // ========================
  static Future<bool> updateProduct(Product product, {XFile? imageFile}) async {
    final url = Uri.parse("$baseUrl/api/products/${product.id}");

    try {
      if (imageFile != null) {
        // ── Multipart: ada foto baru ─────────────────────
        // Laravel tidak mendukung PUT multipart,
        // gunakan POST + _method spoofing
        debugPrint('[API] updateProduct multipart → $url');

        final request = http.MultipartRequest('POST', url);

        request.headers['Accept'] = 'application/json';
        request.fields['_method'] = 'PUT'; // Laravel method spoofing
        request.fields['name'] = product.name;
        request.fields['price'] = product.price.toString();
        request.fields['discount'] = product.discount.toString();
        request.fields['stock'] = product.stock.toString();
        request.fields['jenis'] = product.jenis;
        request.fields['satuan'] = product.satuan;
        request.fields['barcode'] = product.barcode ?? '';

        final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
        final mimeParts = mimeType.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            imageFile.path,
            contentType: MediaType(mimeParts[0], mimeParts[1]),
          ),
        );

        debugPrint('[API] fields: ${request.fields}');
        debugPrint('[API] file: ${imageFile.path} ($mimeType)');

        final streamed = await request.send();
        final responseBody = await streamed.stream.bytesToString();

        debugPrint('[API] updateProduct status: ${streamed.statusCode}');
        debugPrint('[API] updateProduct body: $responseBody');

        return streamed.statusCode == 200;
      } else {
        // ── JSON: tanpa foto (atau hapus foto lama) ──────
        debugPrint('[API] updateProduct JSON → $url');

        final body = {
          'name': product.name,
          'price': product.price,
          'discount': product.discount,
          'stock': product.stock,
          'jenis': product.jenis,
          'satuan': product.satuan,
          'barcode': product.barcode,
          'image': product.image, // null jika foto dihapus
        };

        debugPrint('[API] body: $body');

        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(body),
        );

        debugPrint('[API] updateProduct status: ${response.statusCode}');
        debugPrint('[API] updateProduct body: ${response.body}');

        return response.statusCode == 200;
      }
    } catch (e, stack) {
      debugPrint('[API] updateProduct EXCEPTION: $e');
      debugPrint('[API] $stack');
      rethrow;
    }
  }

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

  // ========================
  // CREATE PRODUCT
  // ========================
  static Future<bool> createProduct(Product product, {XFile? imageFile}) async {
    final url = Uri.parse("$baseUrl/api/products");

    try {
      if (imageFile != null) {
        // ── Multipart: ada foto ──────────────────────────
        debugPrint('[API] createProduct multipart → $url');

        final request = http.MultipartRequest('POST', url);

        // Tambahkan Accept header agar Laravel tidak redirect
        request.headers['Accept'] = 'application/json';

        request.fields['name'] = product.name;
        request.fields['price'] = product.price.toString();
        request.fields['discount'] = product.discount.toString();
        request.fields['stock'] = product.stock.toString();
        request.fields['jenis'] = product.jenis;
        request.fields['satuan'] = product.satuan;
        request.fields['barcode'] = product.barcode ?? '';

        final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
        final mimeParts = mimeType.split('/');

        request.files.add(
          await http.MultipartFile.fromPath(
            'image', // sesuaikan dengan nama field di backend Laravel
            imageFile.path,
            contentType: MediaType(mimeParts[0], mimeParts[1]),
          ),
        );

        debugPrint('[API] fields: ${request.fields}');
        debugPrint('[API] file: ${imageFile.path} ($mimeType)');

        final streamed = await request.send();
        final responseBody = await streamed.stream.bytesToString();

        debugPrint('[API] createProduct status: ${streamed.statusCode}');
        debugPrint('[API] createProduct body: $responseBody');

        return streamed.statusCode == 200 || streamed.statusCode == 201;
      } else {
        // ── JSON: tanpa foto ─────────────────────────────
        debugPrint('[API] createProduct JSON → $url');

        final body = {
          'name': product.name,
          'price': product.price,
          'discount': product.discount,
          'stock': product.stock,
          'jenis': product.jenis,
          'satuan': product.satuan,
          'barcode': product.barcode,
          'image': product.image,
        };

        debugPrint('[API] body: $body');

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(body),
        );

        debugPrint('[API] createProduct status: ${response.statusCode}');
        debugPrint('[API] createProduct body: ${response.body}');

        return response.statusCode == 200 || response.statusCode == 201;
      }
    } catch (e, stack) {
      debugPrint('[API] createProduct EXCEPTION: $e');
      debugPrint('[API] $stack');
      rethrow;
    }
  }

  // ========================
  // DELETE PRODUCT
  // ========================
  static Future<bool> deleteProduct(int id) async {
    final url = Uri.parse("$baseUrl/api/products/$id");

    try {
      debugPrint('[API] deleteProduct → $url');

      final response = await http.delete(
        url,
        headers: {'Accept': 'application/json'},
      );

      debugPrint('[API] deleteProduct status: ${response.statusCode}');
      debugPrint('[API] deleteProduct body: ${response.body}');

      return response.statusCode == 200;
    } catch (e, stack) {
      debugPrint('[API] deleteProduct EXCEPTION: $e');
      debugPrint('[API] $stack');
      rethrow;
    }
  }
}
