import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
import 'package:tugas_akhir/models/product.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/models/bahan_baku.dart';
import 'package:tugas_akhir/models/diskon.dart';
import 'package:tugas_akhir/models/pembelian.dart';
import 'package:tugas_akhir/models/produksi.dart';
import 'package:tugas_akhir/models/resep.dart';
import 'package:tugas_akhir/models/supplier.dart';
import 'package:tugas_akhir/models/user.dart';

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
            headers: {"Connection": "close"},
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
  // GET PRODUCT BY ID
  // ========================
  static Future<Product> getProductById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/products/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load product");
      }
    } catch (e) {
      throw Exception("Gagal memuat produk: $e");
    }
  }

  // ========================
  // CREATE PRODUCT WITH IMAGE
  // ========================
  static Future<bool> createProductWithImage({
    required String name,
    required int price,
    required int discount,
    required int stock,
    required String jenis,
    required String satuan,
    required String barcode,
    required File imageFile,
    int? resepId,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/api/products"),
      );

      // Add headers
      request.headers.addAll({'Connection': 'close'});

      // Add fields
      request.fields['name'] = name;
      request.fields['price'] = price.toString();
      request.fields['discount'] = discount.toString();
      request.fields['stock'] = stock.toString();
      request.fields['jenis'] = jenis;
      request.fields['satuan'] = satuan;
      request.fields['barcode'] = barcode;
      if (resepId != null) {
        request.fields['resep_id'] = resepId.toString();
      }

      // Add image file
      final imageBytes = await imageFile.readAsBytes();
      final imageExtension = imageFile.path.split('.').last.toLowerCase();
      final contentType = _getContentType(imageExtension);

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename:
              'product_${DateTime.now().millisecondsSinceEpoch}.$imageExtension',
          contentType: http_parser.MediaType.parse(contentType),
        ),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat produk dengan gambar: $e");
    }
  }

  // ========================
  // UPDATE PRODUCT WITH IMAGE
  // ========================
  static Future<bool> updateProductWithImage({
    required int id,
    required String name,
    required int price,
    required int discount,
    required int stock,
    required String jenis,
    required String satuan,
    required String barcode,
    File? imageFile,
    int? resepId,
  }) async {
    try {
      final request = http.MultipartRequest(
        'PUT',
        Uri.parse("$baseUrl/api/products/$id"),
      );

      // Add headers
      request.headers.addAll({'Connection': 'close'});

      // Add fields
      request.fields['name'] = name;
      request.fields['price'] = price.toString();
      request.fields['discount'] = discount.toString();
      request.fields['stock'] = stock.toString();
      request.fields['jenis'] = jenis;
      request.fields['satuan'] = satuan;
      request.fields['barcode'] = barcode;
      if (resepId != null) {
        request.fields['resep_id'] = resepId.toString();
      }

      // Add image file if provided
      if (imageFile != null) {
        final imageBytes = await imageFile.readAsBytes();
        final imageExtension = imageFile.path.split('.').last.toLowerCase();
        final contentType = _getContentType(imageExtension);

        request.files.add(
          http.MultipartFile.fromBytes(
            'image',
            imageBytes,
            filename:
                'product_${DateTime.now().millisecondsSinceEpoch}.$imageExtension',
            contentType: http_parser.MediaType.parse(contentType),
          ),
        );
      }

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update produk dengan gambar: $e");
    }
  }

  // Helper method untuk mendapatkan content type berdasarkan extension
  static String _getContentType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  // ========================
  // CREATE PRODUCT (LEGACY - untuk backward compatibility)
  // ========================
  static Future<bool> createProduct(Product product) async {
    try {
      final body = {
        "name": product.name,
        "price": product.price,
        "discount": product.discount,
        "stock": product.stock,
        "jenis": product.jenis,
        "satuan": product.satuan,
        "barcode": product.barcode,
        "image": product.image,
        "resep_id": product.resepId,
      };

      final response = await http
          .post(
            Uri.parse("$baseUrl/api/products"),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat produk: $e");
    }
  }

  // ========================
  // UPDATE PRODUCT
  // ========================
  static Future<bool> updateProduct(Product product) async {
    try {
      final url = Uri.parse("$baseUrl/api/products/${product.id}");

      final body = {
        "name": product.name,
        "price": product.price,
        "discount": product.discount,
        "stock": product.stock,
        "jenis": product.jenis,
        "satuan": product.satuan,
        "barcode": product.barcode,
        "image": product.image,
        "resep_id": product.resepId,
      };

      final response = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update produk: $e");
    }
  }

  // ========================
  // DELETE PRODUCT
  // ========================
  static Future<bool> deleteProduct(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/api/products/$id"), headers: headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus produk: $e");
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
          .post(url, headers: headers, body: jsonEncode(body))
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
            headers: {"Connection": "close"},
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
  static Future<Map<String, dynamic>> getTransactionDetail(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/transactions/$id"),
            headers: {"Connection": "close"},
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

  // ========================
  // BAHAN BAKU APIS
  // ========================
  static Future<List<BahanBaku>> getAllBahanBaku() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/bahan-baku"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List)
            .map((e) => BahanBaku.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to load bahan baku");
      }
    } catch (e) {
      throw Exception("Gagal memuat bahan baku: $e");
    }
  }

  static Future<BahanBaku> getBahanBakuById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/bahan-baku/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BahanBaku.fromJson(data['data']);
      } else {
        throw Exception("Failed to load bahan baku");
      }
    } catch (e) {
      throw Exception("Gagal memuat bahan baku: $e");
    }
  }

  static Future<bool> createBahanBaku(BahanBaku bahanBaku) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/bahan-baku"),
            headers: headers,
            body: jsonEncode(bahanBaku.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat bahan baku: $e");
    }
  }

  static Future<bool> updateBahanBaku(BahanBaku bahanBaku) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/api/bahan-baku/${bahanBaku.id}"),
            headers: headers,
            body: jsonEncode(bahanBaku.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update bahan baku: $e");
    }
  }

  static Future<bool> deleteBahanBaku(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/api/bahan-baku/$id"), headers: headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus bahan baku: $e");
    }
  }

  // ========================
  // DISKON APIS
  // ========================
  static Future<List<Diskon>> getAllDiskon() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/diskon"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List).map((e) => Diskon.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load diskon");
      }
    } catch (e) {
      throw Exception("Gagal memuat diskon: $e");
    }
  }

  static Future<Diskon> getDiskonById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/diskon/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Diskon.fromJson(data['data']);
      } else {
        throw Exception("Failed to load diskon");
      }
    } catch (e) {
      throw Exception("Gagal memuat diskon: $e");
    }
  }

  static Future<bool> createDiskon(Diskon diskon) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/diskon"),
            headers: headers,
            body: jsonEncode(diskon.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat diskon: $e");
    }
  }

  static Future<bool> updateDiskon(Diskon diskon) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/api/diskon/${diskon.id}"),
            headers: headers,
            body: jsonEncode(diskon.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update diskon: $e");
    }
  }

  static Future<bool> deleteDiskon(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/api/diskon/$id"), headers: headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus diskon: $e");
    }
  }

  // ========================
  // SUPPLIER APIS
  // ========================
  static Future<List<Supplier>> getSuppliers() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/supplier"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => Supplier.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load suppliers");
      }
    } catch (e) {
      throw Exception("Gagal memuat supplier: $e");
    }
  }

  static Future<Supplier> getSupplierById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/supplier/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Supplier.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load supplier");
      }
    } catch (e) {
      throw Exception("Gagal memuat supplier: $e");
    }
  }

  static Future<bool> createSupplier(Supplier supplier) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/supplier"),
            headers: headers,
            body: jsonEncode(supplier.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat supplier: $e");
    }
  }

  static Future<bool> updateSupplier(Supplier supplier) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/api/supplier/${supplier.id}"),
            headers: headers,
            body: jsonEncode(supplier.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update supplier: $e");
    }
  }

  static Future<bool> deleteSupplier(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/api/supplier/$id"), headers: headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus supplier: $e");
    }
  }

  // ========================
  // PEMBELIAN APIS
  // ========================
  static Future<List<Pembelian>> getAllPembelian() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/pembelian"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        return data.map((e) => Pembelian.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load pembelian");
      }
    } catch (e) {
      throw Exception("Gagal memuat pembelian: $e");
    }
  }

  static Future<Pembelian> getDetailPembelian(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/pembelian/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return Pembelian.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load detail pembelian");
      }
    } catch (e) {
      throw Exception("Gagal memuat detail pembelian: $e");
    }
  }

  static Future<bool> createPembelian(Pembelian pembelian) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/pembelian"),
            headers: headers,
            body: jsonEncode(pembelian.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat pembelian: $e");
    }
  }

  static Future<bool> deletePembelian(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/api/pembelian/$id"), headers: headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus pembelian: $e");
    }
  }

  // ========================
  // PRODUKSI APIS
  // ========================
  static Future<List<Produksi>> getProduksi() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/produksi"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List).map((e) => Produksi.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load produksi");
      }
    } catch (e) {
      throw Exception("Gagal memuat produksi: $e");
    }
  }

  static Future<bool> createProduksi({
    required int productId,
    required int jumlahProduksi,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/produksi"),
            headers: headers,
            body: jsonEncode({
              'product_id': productId,
              'jumlah_produksi': jumlahProduksi,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat produksi: $e");
    }
  }

  // ========================
  // RESEP APIS
  // ========================
  static Future<List<Resep>> getAllResep() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/resep"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List).map((e) => Resep.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load resep");
      }
    } catch (e) {
      throw Exception("Gagal memuat resep: $e");
    }
  }

  static Future<Resep> getDetailResep(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/resep/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Resep.fromJson({
          'id': data['resep']['id'],
          'nama_resep': data['resep']['nama_resep'],
          'deskripsi': data['resep']['deskripsi'],
          'bahan': data['bahan'],
        });
      } else {
        throw Exception("Failed to load detail resep");
      }
    } catch (e) {
      throw Exception("Gagal memuat detail resep: $e");
    }
  }

  static Future<bool> createResep(Resep resep) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/resep"),
            headers: headers,
            body: jsonEncode({
              'nama_resep': resep.namaResep,
              'deskripsi': resep.deskripsi,
              'bahan': resep.bahan
                  ?.map(
                    (e) => {
                      'bahan_id': e.bahanId,
                      'jumlah_bahan': e.jumlahBahan,
                    },
                  )
                  .toList(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat resep: $e");
    }
  }

  static Future<bool> updateResep(Resep resep) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/api/resep/${resep.id}"),
            headers: headers,
            body: jsonEncode({
              'nama_resep': resep.namaResep,
              'deskripsi': resep.deskripsi,
              'bahan': resep.bahan
                  ?.map(
                    (e) => {
                      'bahan_id': e.bahanId,
                      'jumlah_bahan': e.jumlahBahan,
                    },
                  )
                  .toList(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update resep: $e");
    }
  }

  static Future<bool> deleteResep(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/api/resep/$id"), headers: headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus resep: $e");
    }
  }

  // ========================
  // USER APIS
  // ========================
  static Future<List<User>> getAllUsers() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/users"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List).map((e) => User.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load users");
      }
    } catch (e) {
      throw Exception("Gagal memuat users: $e");
    }
  }

  static Future<User> getUserById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/users/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data['data']);
      } else {
        throw Exception("Failed to load user");
      }
    } catch (e) {
      throw Exception("Gagal memuat user: $e");
    }
  }

  static Future<bool> createUser(User user) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/users"),
            headers: headers,
            body: jsonEncode(user.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat user: $e");
    }
  }

  static Future<bool> updateUser(User user) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/api/users/${user.id}"),
            headers: headers,
            body: jsonEncode(user.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update user: $e");
    }
  }

  static Future<bool> deleteUser(int id) async {
    try {
      final response = await http
          .delete(Uri.parse("$baseUrl/api/users/$id"), headers: headers)
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus user: $e");
    }
  }
}
