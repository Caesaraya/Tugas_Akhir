import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

void main() async {
  final router = Router();

  router.post('/get-snap-token', (Request request) async {
    print("🔥 REQUEST MASUK KE BACKEND");

    final body = await request.readAsString();
    print("📥 BODY DARI FLUTTER: $body");

    final payload = jsonDecode(body);

    const serverKey = 'Mid-server-ZyYvVpBoK1CSIAyfbkcOCTTS';
    final auth =
        'Basic ${base64.encode(utf8.encode('$serverKey:'))}';

    final response = await http.post(
      Uri.parse('https://app.sandbox.midtrans.com/snap/v1/transactions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': auth,
      },
      body: jsonEncode({
        "transaction_details": {
          "order_id": "MOVIE-${DateTime.now().millisecondsSinceEpoch}",
          "gross_amount": payload['amount'],
        },
        "item_details": [
          {
            "id": "movie-01",
            "price": payload['amount'],
            "quantity": 1,
            "name": payload['movie_title'],
          }
        ]
      }),
    );

    print("🔥 RESPONSE DARI MIDTRANS:");
    print(response.body);

    return Response.ok(
      response.body,
      headers: {'Content-Type': 'application/json'},
    );
  });
final server = await serve(
  router,
  InternetAddress.anyIPv4,
  3000,
);

  print('🚀 Backend Midtrans Sandbox jalan di http://0.0.0.0:3000');
}