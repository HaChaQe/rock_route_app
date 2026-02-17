import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/location_provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/venue_model.dart';
import 'package:rock_route/features/venues/presentation/widgets/venue_detail_sheet.dart';
import '../providers/favorites_provider.dart';

class VenueCard extends ConsumerWidget {
  final VenueModel venue;

  const VenueCard({super.key, required this.venue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final locationAsync = ref.watch(currentLocationProvider);
    final favoriteIds = ref.watch(favoritesProvider);
    final isFavorite = favoriteIds.contains(venue.id); // mekan favlarda var mı?
    
    String distanceText = '';

    locationAsync.whenData((position){
      if (position != null) {
        double distanceInMeters = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          venue.latitude,
          venue.longitude
        );

        double distanceInKM = distanceInMeters / 1000;
        distanceText = '${distanceInKM.toStringAsFixed(1)} km';
      }
    });

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          onTap: () {
            showVenueDetailSheet(context, venue);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadiusGeometry.vertical(top: Radius.circular(AppConstants.borderRadius)),
                    child: Image.asset(
                      venue.imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 150,
                        color: Colors.grey[800],
                        child: const Center(child: Icon(Icons.music_note_outlined, color: Colors.white)),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        child: IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.redAccent : Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).toggleFavorite(venue.id);
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            venue.name,
                            style: const TextStyle(
                              color: AppConstants.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppConstants.primaryColor)
                          ),
                          child: Row(
                            children: [
                              if (distanceText.isNotEmpty) ...[
                                const Icon(Icons.location_on, size: 12, color: AppConstants.primaryColor),
                                const SizedBox(width: 2),
                                Text(
                                  distanceText,
                                  style: const TextStyle(
                                    color: AppConstants.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(width: 1, height: 12, color: AppConstants.primaryColor.withValues(alpha: 0.3)),
                                const SizedBox(width: 6)
                              ],
                              Text(
                                "★ ${venue.rating}",
                                style: const TextStyle(
                                  color: AppConstants.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      venue.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppConstants.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}