import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rock_route/features/venues/presentation/pages/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
// import 'features/venues/presentation/pages/home_page.dart';
import 'features/venues/presentation/providers/favorites_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //flutter konusmaya hazır mı?
  final prefs = await SharedPreferences.getInstance();

  await dotenv.load(fileName: ".env");

  runApp(
    ProviderScope(
      // Yüklediğimiz hafızayı Riverpod'un içine enjekte ediyoruz
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const RockRouteApp(),
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