import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/date_symbol_data_local.dart'; // 1. Tambahkan import untuk inisialisasi format tanggal
import 'package:tugas_akhir/bindings/bindings.dart';
import 'package:tugas_akhir/routes/pages.dart';
import 'package:tugas_akhir/routes/routes.dart';

// 2. Mengubah fungsi main menjadi async
void main() async {
  // 3. Pastikan binding framework Flutter sudah siap sebelum melakukan await
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Inisialisasi locale Indonesia ('id_ID') agar format mata uang & tanggal tidak error
  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF26C6DA)),
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF26C6DA)),
      ),
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.mediaQuery,
      getPages: AppPages.pages,
    );
  }
}
