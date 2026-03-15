import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rock_route/core/constants/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart'; 
import '../../data/models/event_model.dart';
import '../../../venues/presentation/providers/location_provider.dart';
import '../../../ai_assistant/data/models/presentation/providers/chat_provider.dart';
import '../../../ai_assistant/data/models/presentation/pages/chat_page.dart';

void showEventDetailSheet(BuildContext context, EventModel event, {bool isVenueFocused = false}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Consumer(
        builder: (context, ref, child) {
          // Mesafe Hesaplama
          final locationAsync = ref.watch(currentLocationProvider);
          String distanceText = '';

          locationAsync.whenData((position) {
            if (position != null && event.latitude != null && event.longitude != null) {
              double distanceInMeters = Geolocator.distanceBetween(
                position.latitude, position.longitude, event.latitude!, event.longitude!,
              );
              distanceText = '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
            }
          });

          // Tarih Formatı
          String formattedDate = DateFormat('dd.MM.yyyy').format(event.date);

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
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, -2))],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(2)))),
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
                                  // 🤘 ANA BAŞLIK: Haritadaysa 6:45 (Mekan), Listedeyse Pentagram (Konser)
                                  Expanded(
                                    child: Text(
                                      isVenueFocused ? event.venueName : event.name, 
                                      style: const TextStyle(
                                        color: AppConstants.textPrimary,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // BADGE: Haritadaysa KM, Listedeyse Tarih
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: AppConstants.secondaryColor.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppConstants.secondaryColor),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(isVenueFocused ? Icons.location_on : Icons.calendar_today, size: 12, color: AppConstants.secondaryColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          isVenueFocused 
                                              ? (distanceText.isNotEmpty ? distanceText : "Yakında") 
                                              : formattedDate,
                                          style: const TextStyle(color: AppConstants.secondaryColor, fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // 🤘 TEMİZLİK BURADA YAPILDI: 
                              // Eğer haritadan açıldıysa (isVenueFocused) ALT BAŞLIK HİÇ YAZMAYACAK! Tertemiz olacak.
                              // Eğer listeden açıldıysa mekan adı yazacak.
                              if (!isVenueFocused) ...[
                                Text(
                                  event.venueName.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppConstants.secondaryColor,
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // 🤘 Ekrana "Yakında şu konserler var" YAZDIRMIYORUZ. Sadece bu sabit metin var.
                              const Text(
                                "Bu etkinlik için bilet bilgilerine ve mekan detaylarına aşağıdan ulaşabilirsin. Ronnie'ye danışarak rock ortamı hakkında bilgi alabilirsin.",
                                style: TextStyle(color: AppConstants.textSecondary, fontSize: 14, height: 1.5),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),

                      // 🤘 BARMENE SOR (BİLGİ SADECE BURADA GİZLİ)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                        child: SizedBox(
                          width: 330,
                          child: TextButton.icon(
                            onPressed: () {
                              // Ekranda görünmeyen ama Ronnie'nin okuduğu mesaj:
                              String prompt = isVenueFocused 
                                  ? "${event.venueName} sence nasıl bir mekan kanka? Yakında konserler var mı?"
                                  : "${event.venueName} mekanındaki ${event.name} konseri sence kafa açar mı?";

                              ref.read(chatProvider.notifier).sendMessage(prompt);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()));
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppConstants.textSecondary,
                              backgroundColor: AppConstants.surfaceColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                            ),
                            icon: const Icon(Icons.auto_awesome, color: AppConstants.secondaryColor),
                            label: Text(
                              isVenueFocused 
                                  ? "Ronnie'ye Danış: Bu mekan nasıl?" 
                                  : "Ronnie'ye Danış: Bu konser kafa açar mı?"
                            ),
                          ),
                        ),
                      ),
                      
                      // Alt Aksiyon Butonları (Harita ve Biletix)
                      SafeArea(
                        top: false,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppConstants.surfaceColor, border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05)))),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    if (event.latitude != null && event.longitude != null) {
                                      _launchMapsUrl(event.latitude!, event.longitude!, event.venueName);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.primaryColor, foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.map_outlined), label: const Text("Haritada Gör", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _launchBiletixVenueUrl(event.venueName);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppConstants.secondaryColor, foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  icon: const Icon(Icons.confirmation_number_outlined), label: const Text("Biletix", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
  '6:45 kk': '6 45 Kaybedenler Kulübü', 
  '6:45': '6 45',
};

Future<void> _launchBiletixVenueUrl(String venueName) async {
  if (venueName.isEmpty) return;
  String normalized = _biletixVenueNameMap[venueName.toLowerCase().trim()] ?? venueName;
  normalized = normalized.replaceAll(':', ' ');
  final encoded = Uri.encodeComponent(normalized);
  final Uri uri = Uri.parse("https://www.biletix.com/search/TURKIYE/tr?searchq=$encoded#$encoded");
  if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
    debugPrint("Link açılamadı.");
  }
}

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