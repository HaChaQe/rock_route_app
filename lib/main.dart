import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rock_route/widgets/event_card.dart';
import 'views/home/home_view.dart';

void main(){
  runApp(const ProviderScope(child: RockRouteApp()));
}

class RockRouteApp extends StatelessWidget {
  const RockRouteApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Rock Route',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          centerTitle: true,
        )
      ),

      home: const Scaffold(
        body: const HomeView(),
      ),
    );
  }

}
