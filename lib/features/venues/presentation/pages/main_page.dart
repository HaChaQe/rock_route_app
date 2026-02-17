import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import 'home_page.dart';
import 'map_page.dart';
import 'favorites_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MapPage(),
    const FavoritesPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppConstants.surfaceColor,
        indicatorColor: AppConstants.primaryColor.withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore, color: AppConstants.primaryColor,), label: "Keşfet"),
          NavigationDestination(icon: Icon(Icons.map_outlined, color: AppConstants.primaryColor,), label: "Harita"),
          NavigationDestination(icon: Icon(Icons.favorite, color: AppConstants.primaryColor,), label: "Favoriler")
        ],
      ),
    );
  }
}