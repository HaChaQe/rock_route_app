import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rock_route/core/constants/app_constants.dart';
import 'package:rock_route/features/venues/data/models/venue_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/location_provider.dart';
import '../providers/favorites_provider.dart';

void showVenueDetailSheet(BuildContext context, VenueModel venue) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final favoriteIds = ref.watch(favoritesProvider);
            final isFavorite = favoriteIds.contains(venue.id); // mekan favlarda var mı?

            final locationAsync = ref.watch(currentLocationProvider);
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
          
          return DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.35,
            maxChildSize: 0.6,
            builder: (context, scrollController) {
              return TapRegion(
                onTapOutside: (event) {
                  Navigator.pop(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppConstants.surfaceColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, -2))
                    ]
                  ),
                  child: Column(
                    children: [
                      // 1. TUTMA ÇUBUĞU (Sabit)
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(2)
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                
                      // 2. KAYDIRILABİLİR İÇERİK (Yazılar Buraya)
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16), // Kenar boşlukları
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Başlık ve Puan
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      venue.name,
                                      style: const TextStyle(
                                        color: AppConstants.textPrimary,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppConstants.primaryColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppConstants.primaryColor)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
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
                              
                              const SizedBox(height: 8),
                              
                              // Kategori
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    venue.category.toUpperCase(),
                                    style: TextStyle(
                                      color: AppConstants.textSecondary.withValues(alpha: 0.7),
                                      fontSize: 12,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? Colors.redAccent : Colors.grey,
                                      size: 26,
                                    ),
                                    onPressed: (){
                                      ref.read(favoritesProvider.notifier).toggleFavorite(venue.id);
                                    } 
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 8),
                              
                              // Açıklama
                              Text(
                                venue.description,
                                style: const TextStyle(color: AppConstants.textSecondary, fontSize: 14, height: 1.5),
                              ),
                              
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                
                      // 3. SABİT BUTON (Scroll'un Dışında!)
                      SafeArea(
                        top: false,
                        child: Container(
                          padding: const EdgeInsets.all(16), // Butonun kenar boşlukları
                          decoration: BoxDecoration(
                            color: AppConstants.surfaceColor,
                            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context); // Sheet'i kapat
                                _launchMapsUrl(venue.latitude, venue.longitude); // Haritayı aç
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              icon: const Icon(Icons.map_outlined),
                              label: const Text("Haritada Göster", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          },
        );
      },
    );
  }

  Future<void> _launchMapsUrl(double lat, double lon) async {
    final uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw Exception("Haritayı açamiyik: $uri");}
    } on Exception catch (e) {
      debugPrint("Hata: $e");
    }
  }