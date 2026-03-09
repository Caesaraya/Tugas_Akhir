import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {

  static const String baseUrl =
      "http://10.10.15.210:3000/api";

  static Future<List<Product>> getProducts() async {

    final response = await http.get(
      Uri.parse("$baseUrl/products"),
    );

    if (response.statusCode == 200) {

      List data = jsonDecode(response.body);

      return data
          .map((e) => Product.fromJson(e))
          .toList();

    } else {

      throw Exception("Failed to load products");

    }

  }
}