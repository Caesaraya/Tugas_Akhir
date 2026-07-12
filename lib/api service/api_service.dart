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
import 'package:tugas_akhir/models/bahan_baku_requirement.dart';
import 'package:tugas_akhir/models/financial_report.dart';
import 'package:tugas_akhir/models/expense_category.dart';
import 'package:tugas_akhir/models/expense.dart';
import 'package:tugas_akhir/models/dashboard_summary.dart';
import 'package:tugas_akhir/models/dashboard_activity.dart';

class ApiService {
  static const String baseUrl =
      "http://103.67.78.70";

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
  // SOFT DELETE PRODUCT
  // ========================
  static Future<bool> softDeleteProduct(int id) async {
    try {
      final response = await http
          .patch(
            Uri.parse("$baseUrl/api/products/$id/delete"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal soft delete produk: $e");
    }
  }

  // ========================
  // RESTORE PRODUCT
  // ========================
  static Future<bool> restoreProduct(int id) async {
    try {
      final response = await http
          .patch(
            Uri.parse("$baseUrl/api/products/$id/restore"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal restore produk: $e");
    }
  }

  // ========================
  // FORCE DELETE PRODUCT
  // ========================
  static Future<bool> forceDeleteProduct(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse("$baseUrl/api/products/$id/force"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal force delete produk: $e");
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

  // ========================
  // PENGAMBILAN BAHAN MANUAL
  // ========================
  static Future<bool> createPengambilanBahanManual({
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/bahan-baku/pengambilan-manual"),
            headers: headers,
            body: jsonEncode({"items": items}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      throw Exception("Gagal melakukan pengambilan bahan manual: $e");
    }
  }

  static Future<Map<String, dynamic>> confirmPengambilanBahanResep({
    required int resepId,
    required int jumlahProduksi,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/pengambilan-bahan/resep"),
            headers: headers,
            body: jsonEncode({
              "resep_id": resepId,
              "jumlah_produksi": jumlahProduksi,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      }

      throw Exception(data['message'] ?? "Gagal memproses pengambilan bahan berdasarkan resep");
    } catch (e) {
      throw Exception("Gagal memproses pengambilan bahan berdasarkan resep: $e");
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
  // SOFT DELETE BAHAN BAKU
  // ========================
  static Future<bool> softDeleteBahanBaku(int id) async {
    try {
      final response = await http
          .patch(
            Uri.parse("$baseUrl/api/bahan-baku/$id/delete"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal soft delete bahan baku: $e");
    }
  }

  // ========================
  // RESTORE BAHAN BAKU
  // ========================
  static Future<bool> restoreBahanBaku(int id) async {
    try {
      final response = await http
          .patch(
            Uri.parse("$baseUrl/api/bahan-baku/$id/restore"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal restore bahan baku: $e");
    }
  }

  // ========================
  // FORCE DELETE BAHAN BAKU
  // ========================
  static Future<bool> forceDeleteBahanBaku(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse("$baseUrl/api/bahan-baku/$id/force"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal force delete bahan baku: $e");
    }
  }

  // ========================
  // CHECK USAGE BAHAN BAKU
  // ========================
  static Future<BahanUsageResult> checkUsageBahanBaku(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/bahan-baku/$id/check-usage"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BahanUsageResult.fromJson(data);
      } else {
        throw Exception("Failed to check bahan usage");
      }
    } catch (e) {
      throw Exception("Gagal cek penggunaan bahan: $e");
    }
  }

  // ========================
  // GET STOCK SUMMARY
  // ========================
  static Future<StockSummaryResult> getStockSummary() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/bahan-baku/summary/stock"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return StockSummaryResult.fromJson(data);
      } else {
        throw Exception("Failed to get stock summary");
      }
    } catch (e) {
      throw Exception("Gagal mengambil summary stok: $e");
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

  static Future<Produksi> getProduksiById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/produksi/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Produksi.fromJson(data['data']);
      } else {
        throw Exception("Failed to get produksi detail");
      }
    } catch (e) {
      throw Exception("Gagal mengambil detail produksi: $e");
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
  // SOFT DELETE RESEP
  // ========================
  static Future<bool> softDeleteResep(int id) async {
    try {
      final response = await http
          .patch(
            Uri.parse("$baseUrl/api/resep/$id/delete"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal soft delete resep: $e");
    }
  }

  // ========================
  // RESTORE RESEP
  // ========================
  static Future<bool> restoreResep(int id) async {
    try {
      final response = await http
          .patch(
            Uri.parse("$baseUrl/api/resep/$id/restore"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal restore resep: $e");
    }
  }

  // ========================
  // FORCE DELETE RESEP
  // ========================
  static Future<bool> forceDeleteResep(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse("$baseUrl/api/resep/$id/force"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal force delete resep: $e");
    }
  }

  // ========================
  // USER APIS
  // ========================

  // LOGIN
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/users/login"),
            headers: headers,
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return data['user'];
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception("Login gagal: $e");
    }
  }

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

  // ========================
  // BAKERY CALCULATION APIS
  // ========================
  static Future<BakeryCalculationResult> hitungKebutuhanBahan({
    required int produkId,
    required int quantity,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/bakery/hitung-kebutuhan")
                .replace(queryParameters: {
              'produk_id': produkId.toString(),
              'quantity': quantity.toString(),
            }),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BakeryCalculationResult.fromJson(data);
      } else {
        throw Exception("Failed to calculate ingredient requirements");
      }
    } catch (e) {
      throw Exception("Gagal menghitung kebutuhan bahan: $e");
    }
  }

  static Future<BakeryAvailabilityResult> cekKetersediaanBahan({
    required int produkId,
    required int quantity,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/bakery/cek-ketersediaan")
                .replace(queryParameters: {
              'produk_id': produkId.toString(),
              'quantity': quantity.toString(),
            }),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BakeryAvailabilityResult.fromJson(data);
      } else {
        throw Exception("Failed to check ingredient availability");
      }
    } catch (e) {
      throw Exception("Gagal cek ketersediaan bahan: $e");
    }
  }

  static Future<BakeryCostResult> hitungBiayaProduksi({
    required int produkId,
    required int quantity,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/bakery/hitung-biaya")
                .replace(queryParameters: {
              'produk_id': produkId.toString(),
              'quantity': quantity.toString(),
            }),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return BakeryCostResult.fromJson(data);
      } else {
        throw Exception("Failed to calculate production cost");
      }
    } catch (e) {
      throw Exception("Gagal hitung biaya produksi: $e");
    }
  }

  static Future<List<ProduksiPossibleItem>> getProduksiPossible({
    int? quantity,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (quantity != null) {
        queryParams['quantity'] = quantity.toString();
      }

      final response = await http
          .get(
            Uri.parse("$baseUrl/api/bakery/produksi-possible")
                .replace(queryParameters: queryParams),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['data'] as List)
            .map((e) => ProduksiPossibleItem.fromJson(e))
            .toList();
      } else {
        throw Exception("Failed to get production possibilities");
      }
    } catch (e) {
      throw Exception("Gagal get produksi possible: $e");
    }
  }

  // ========================
  // FINANCIAL REPORTS
  // ========================
  static Future<List<FinancialReport>> getFinancialReports() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/financial"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((e) => FinancialReport.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception("Failed to load financial reports");
      }
    } catch (e) {
      throw Exception("Gagal memuat laporan keuangan: $e");
    }
  }

  static Future<FinancialReport?> getFinancialReportByMonth(
      int tahun, int bulan) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/financial/$tahun/$bulan"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return FinancialReport.fromJson(data['data']);
        }
        return null;
      } else {
        throw Exception("Failed to load financial report");
      }
    } catch (e) {
      throw Exception("Gagal memuat laporan keuangan: $e");
    }
  }

  static Future<FinancialSummary?> getFinancialSummary() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/financial/summary"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return FinancialSummary.fromJson(data['data']);
        }
        return null;
      } else {
        throw Exception("Failed to load financial summary");
      }
    } catch (e) {
      throw Exception("Gagal memuat summary keuangan: $e");
    }
  }

  static Future<bool> generateFinancialReport(int tahun, int bulan) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/financial/generate"),
            headers: headers,
            body: jsonEncode({
              "tahun": tahun,
              "bulan": bulan,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal generate laporan keuangan: $e");
    }
  }

  static Future<bool> deleteFinancialReport(int tahun, int bulan) async {
    try {
      final response = await http
          .delete(
            Uri.parse("$baseUrl/api/financial/$tahun/$bulan"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus laporan keuangan: $e");
    }
  }

  // ========================
  // EXPENSE CATEGORY APIS
  // ========================
  static Future<List<ExpenseCategory>> getAllExpenseCategories() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/expenses/categories"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((e) => ExpenseCategory.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception("Failed to load expense categories");
      }
    } catch (e) {
      throw Exception("Gagal memuat kategori pengeluaran: $e");
    }
  }

  static Future<ExpenseCategory> getExpenseCategoryById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/expenses/categories/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return ExpenseCategory.fromJson(data['data']);
        }
        throw Exception("Expense category not found");
      } else {
        throw Exception("Failed to load expense category");
      }
    } catch (e) {
      throw Exception("Gagal memuat kategori pengeluaran: $e");
    }
  }

  static Future<bool> createExpenseCategory({
    required String name,
    String? description,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/expenses/categories"),
            headers: headers,
            body: jsonEncode({
              "name": name,
              "description": description,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat kategori pengeluaran: $e");
    }
  }

  static Future<bool> updateExpenseCategory({
    required int id,
    required String name,
    String? description,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/api/expenses/categories/$id"),
            headers: headers,
            body: jsonEncode({
              "name": name,
              "description": description,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update kategori pengeluaran: $e");
    }
  }

  static Future<bool> deleteExpenseCategory(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse("$baseUrl/api/expenses/categories/$id"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus kategori pengeluaran: $e");
    }
  }

  // ========================
  // EXPENSE APIS
  // ========================
  static Future<List<Expense>> getAllExpenses({
    int? categoryId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }
      if (startDate != null) {
        queryParams['start_date'] = startDate;
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate;
      }

      final response = await http
          .get(
            Uri.parse("$baseUrl/api/expenses")
                .replace(queryParameters: queryParams),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((e) => Expense.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception("Failed to load expenses");
      }
    } catch (e) {
      throw Exception("Gagal memuat pengeluaran: $e");
    }
  }

  static Future<Expense> getExpenseById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/expenses/$id"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return Expense.fromJson(data['data']);
        }
        throw Exception("Expense not found");
      } else {
        throw Exception("Failed to load expense");
      }
    } catch (e) {
      throw Exception("Gagal memuat pengeluaran: $e");
    }
  }

  static Future<bool> createExpense({
    required String tanggal,
    required int categoryId,
    required double nominal,
    String? keterangan,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse("$baseUrl/api/expenses"),
            headers: headers,
            body: jsonEncode({
              "tanggal": tanggal,
              "category_id": categoryId,
              "nominal": nominal,
              "keterangan": keterangan,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal membuat pengeluaran: $e");
    }
  }

  static Future<bool> updateExpense({
    required int id,
    required String tanggal,
    required int categoryId,
    required double nominal,
    String? keterangan,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse("$baseUrl/api/expenses/$id"),
            headers: headers,
            body: jsonEncode({
              "tanggal": tanggal,
              "category_id": categoryId,
              "nominal": nominal,
              "keterangan": keterangan,
            }),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal update pengeluaran: $e");
    }
  }

  static Future<bool> deleteExpense(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse("$baseUrl/api/expenses/$id"),
            headers: headers,
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Gagal hapus pengeluaran: $e");
    }
  }

  static Future<Map<String, dynamic>> getExpenseSummaryByMonth(
      int tahun, int bulan) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/expenses/summary/$tahun/$bulan"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
        return {};
      } else {
        throw Exception("Failed to load expense summary");
      }
    } catch (e) {
      throw Exception("Gagal memuat summary pengeluaran: $e");
    }
  }

  // ========================
  // DASHBOARD APIS
  // ========================
  static Future<DashboardSummary> getDashboardSummary() async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/dashboard/summary"),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return DashboardSummary.fromJson(data['data']);
        }
        throw Exception("Failed to load dashboard summary");
      } else {
        throw Exception("Failed to load dashboard summary");
      }
    } catch (e) {
      throw Exception("Gagal memuat dashboard summary: $e");
    }
  }

  static Future<List<DashboardActivity>> getDashboardActivities({
    int limit = 10,
  }) async {
    try {
      final response = await http
          .get(
            Uri.parse("$baseUrl/api/dashboard/activities")
                .replace(queryParameters: {'limit': limit.toString()}),
            headers: {"Connection": "close"},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((e) => DashboardActivity.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception("Failed to load dashboard activities");
      }
    } catch (e) {
      throw Exception("Gagal memuat dashboard activities: $e");
    }
  }
}
