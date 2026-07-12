import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tugas_akhir/bindings/bindings.dart';
import 'package:tugas_akhir/data/sync/bootstrap.dart';
import 'package:tugas_akhir/routes/pages.dart';
import 'package:tugas_akhir/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await initOfflineFirst();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
