import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🤘 Riverpod'u ekledik
import '../../../../core/constants/app_constants.dart';
import 'home_page.dart'; // isEventViewProvider buradan veya events_providers'dan gelmeli
import 'map_page.dart';
import 'favorites_page.dart';
import '../../../ai_assistant/data/models/presentation/pages/chat_page.dart';

// 🤘 StatefulWidget yerine ConsumerStatefulWidget yaptık ki Riverpod'u dinlesin
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MapPage(),
    const FavoritesPage()
  ];

  @override
  Widget build(BuildContext context) {
    // 🤘 1. SİHİRLİ ŞALTERİ BURADA DA DİNLİYORUZ!
    final isEventView = ref.watch(isEventViewProvider); 
    
    // 🤘 2. RENGİMİZİ BELİRLİYORUZ (Konser ise Yeşil, Mekan ise Mor)
    // main_page.dart içindeki build metodu

    final activeColor = isEventView ? AppConstants.secondaryColor : AppConstants.primaryColor;

    return Scaffold(
      body: _pages[_currentIndex],
      // 🤘 GERÇEK NEON RONNIE FAB (Glow ve Çerçeve Geri Geldi!)
      floatingActionButton: Container(
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            // 🟠 Neon Parlama (Glow)
            BoxShadow(
              color: AppConstants.ronnieColor.withValues(alpha: 0.5), 
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
          },
          backgroundColor: AppConstants.surfaceColor, // İçi koyu kalsın ki neon parlasın
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            // 🤘 Neon Turuncu Çerçeve
            side: const BorderSide(color: AppConstants.ronnieColor, width: 2), 
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Image.asset(
              'assets/images/rock.png',
              width: 26,
              height: 26,
              fit: BoxFit.contain,
              color: AppConstants.ronnieColor,
              // Kanka asset hala gelmediyse kırmızı ekran yerine rock işareti çıksın diye koruma:
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.sports_bar, 
                color: AppConstants.ronnieColor, 
                size: 26
              ),
            ),
          ),
        ),
      ),

      // 🤘 NAV BAR GÜNCELLEMESİ
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // Pasif ve aktif tüm yazıların rengini ayarlıyoruz
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(color: activeColor, fontWeight: FontWeight.bold, fontSize: 12);
            }
            return TextStyle(color: activeColor.withValues(alpha: 0.6), fontSize: 12); // Pasifse biraz soluk
          }),
          // İkonların rengini ayarlıyoruz
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return IconThemeData(color: activeColor, size: 28);
            }
            return IconThemeData(color: activeColor.withValues(alpha: 0.6), size: 24);
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (int index) => setState(() => _currentIndex = index),
          backgroundColor: AppConstants.surfaceColor,
          indicatorColor: activeColor.withValues(alpha: 0.15),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.explore), label: "Keşfet"),
            NavigationDestination(icon: Icon(Icons.map_outlined), label: "Harita"),
            NavigationDestination(icon: Icon(Icons.favorite), label: "Favoriler"),
          ],
        ),
      ),
    );
  }
}