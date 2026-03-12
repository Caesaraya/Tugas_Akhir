import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl =
      "https://oafishly-noncontagious-cali.ngrok-free.dev/api/products";

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception(
        "Failed to load products. Status code: ${response.statusCode}",
      );
    }
  }
}
