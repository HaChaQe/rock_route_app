import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rock_route/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/event_model.dart';
import '../../../venues/presentation/providers/location_provider.dart';

void showEventDetailSheet(BuildContext context, EventModel event) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          // 🤘 MESAFE HESAPLAMA
          final locationAsync = ref.watch(currentLocationProvider);
          String distanceText = '';

          locationAsync.whenData((position) {
            if (position != null && event.latitude != null && event.longitude != null) {
              double distanceInMeters = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                event.latitude!,
                event.longitude!,
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
                onTapOutside: (e) => Navigator.pop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppConstants.surfaceColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Center(
                        child: Container(
                          width: 40, height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      event.venueName, 
                                      style: const TextStyle(
                                        color: AppConstants.textPrimary,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if (distanceText.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppConstants.secondaryColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: AppConstants.secondaryColor),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.location_on, size: 12, color: AppConstants.secondaryColor),
                                          const SizedBox(width: 2),
                                          Text(
                                            distanceText,
                                            style: const TextStyle(
                                              color: AppConstants.secondaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              Text(
                                "KONSER MEKANI",
                                style: TextStyle(
                                  color: AppConstants.textSecondary.withValues(alpha: 0.7),
                                  fontSize: 12,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              const Text(
                                "Bu mekan için güncel bilet listesine Biletix üzerinden doğrudan ulaşabilirsin.",
                                style: TextStyle(
                                  color: AppConstants.textSecondary,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // SafeArea(
                      //   top: false,
                      //   child: Container(
                      //     padding: const EdgeInsets.all(16),
                      //     decoration: BoxDecoration(
                      //       color: AppConstants.surfaceColor,
                      //       border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                      //     ),
                      //     child: SizedBox(
                      //       width: double.infinity,
                      //       child: ElevatedButton.icon(
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //           // 🤘 İsmi Biletix'e göndermeden önce pürüzsüz yapıyoruz
                      //           _launchBiletixVenueUrl(event.venueName);
                      //         },
                      //         style: ElevatedButton.styleFrom(
                      //           backgroundColor: AppConstants.secondaryColor,
                      //           foregroundColor: Colors.black,
                      //           padding: const EdgeInsets.symmetric(vertical: 16),
                      //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      //         ),
                      //         icon: const Icon(Icons.confirmation_number_outlined),
                      //         label: const Text(
                      //           "Biletix Mekan Sayfası",
                      //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SafeArea(
                        top: false,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppConstants.surfaceColor,
                            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
                          ),
                          child: Row(
                            children: [
                              // Haritada Göster butonu
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    if (event.latitude != null && event.longitude != null) {
                                      _launchMapsUrl(event.latitude!, event.longitude!, event.venueName);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.map_outlined),
                                  label: const Text("Haritada Gör", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Biletix butonu
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _launchBiletixVenueUrl(event.venueName);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.secondaryColor,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.confirmation_number_outlined),
                                  label: const Text("Biletix", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
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

const Map<String, String> _biletixVenueNameMap = {
  'bostancı showland': 'Bostancı Gösteri Merkezi',
  // yeni uyuşmazlık buldukça buraya eklersin
};

Future<void> _launchBiletixVenueUrl(String venueName) async {
  if (venueName.isEmpty) return;

  final normalized = _biletixVenueNameMap[venueName.toLowerCase().trim()] ?? venueName;
  final encoded = Uri.encodeComponent(normalized);

  final Uri uri = Uri.parse(
    "https://www.biletix.com/search/TURKIYE/tr?searchq=$encoded#$encoded"
  );

  debugPrint("🚀 Biletix'e fişeklenen link: $uri");

  if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
    debugPrint("Link açılamadı.");
  }
}

// Future<void> _launchMapsUrl(double lat, double lon) async {
//   final uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lon");
//   try {
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       throw Exception("Haritayı açamadık: $uri");
//     }
//   } on Exception catch (e) {
//     debugPrint("Hata: $e");
//   }
// }

Future<void> _launchMapsUrl(double lat, double lon, String name) async {
  final encodedName = Uri.encodeComponent(name);
  final uri = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=$encodedName&center=$lat,$lon"
  );
  try {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Haritayı açamadık: $uri");
    }
  } on Exception catch (e) {
    debugPrint("Hata: $e");
  }
}