// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rock_route/features/venues/presentation/pages/main_page.dart';
import 'core/constants/app_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //flutter konusmaya hazır mı?

  try {
    await dotenv.load(fileName: ".env");
    print("ENV YÜKLENDİ! ŞİFRE: ${dotenv.env['GOOGLE_API_KEY']}");
  } catch (e) {
    print("ENV DOSYASI BULUNAMADI! HATA: $e");
  }

  runApp(
    const ProviderScope(
      child: RockRouteApp(),
    ),
  );
}

class RockRouteApp extends StatelessWidget {
  const RockRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        useMaterial3: true
      ),
      home: const MainPage(),
    );
  }
}