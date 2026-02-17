import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/venue_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/venue_card.dart';
import '../../../../core/constants/app_constants.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venueState = ref.watch(venueProvider);
    final favoriteIds = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favori Mekanlarım", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: venueState.when(
        error: (error, stack) => Center(child: Text('Hata oluştu: $error')),
        loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
        data: (venues) {
          final favoriteVenues = venues.where((venue) => favoriteIds.contains(venue.id)).toList();

          if (favoriteVenues.isEmpty) {
            return Center(
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
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteVenues.length,
            itemBuilder: (context, index) {
              final venue = favoriteVenues[index];
              return VenueCard(venue: venue);
            },
          );
        },
      ),
    );
  }
}