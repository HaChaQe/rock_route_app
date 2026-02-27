import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_provider.dart';
import '../widgets/venue_card.dart';
import '../../../../core/constants/app_constants.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteVenues = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favori Mekanlarım", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: favoriteVenues.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.heart_broken, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    "Henüz hiç favori mekanın yok.\nHemen keşfetmeye başla!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppConstants.secondaryColor, fontSize: 16),
                  )
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteVenues.length,
              itemBuilder: (context, index) {
                return VenueCard(venue: favoriteVenues[index]);
              },
            ),
    );
  }
}