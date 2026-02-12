import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_constants.dart';
import 'features/venues/presentation/pages/home_page.dart';

void main() {
  runApp(
    const ProviderScope(child: RockRouteApp())
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
      home: const HomePage(),
    );
  }
}