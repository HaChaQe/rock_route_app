// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../../core/constants/app_constants.dart';
// import '../providers/venue_provider.dart';
// import '../widgets/venue_card.dart';
// import '../widgets/venue_shimmer_list.dart';
// import '../../../events/presentations/widgets/events_list_view.dart';
// import '../../../events/presentations/providers/events_providers.dart';


// final List<String> _categories = ["Tümü", "Rock Bar", "Pub", "Canlı Müzik", "Metal"];

// class HomePage extends ConsumerWidget{
//   const HomePage ({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref){
//     final filteredState = ref.watch(filteredVenuesProvider);
//     final isEventView = ref.watch(isEventViewProvider);
//     final selectedCategory = ref.watch(selectedCategoryProvider);

//     return Scaffold(
//       backgroundColor: AppConstants.backgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           AppConstants.appName,
//           style: TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryColor),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//       ),
      
//       body: Column(
//         children: [
//           SizedBox(
//             height: 60,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
//               itemCount: _categories.length,
//               itemBuilder: (context, index) {
//                 final category = _categories[index];
//                 final isSelected = selectedCategory == category;

//                 return Padding(
//                   padding: const EdgeInsets.only(right: 8.0),
//                   child: ChoiceChip(
//                     label: Text(
//                       category,
//                       style: TextStyle(
//                         color: isSelected ? Colors.black : AppConstants.textPrimary,
//                         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
//                       ),
//                     ),
//                     selected: isSelected,
//                     selectedColor: AppConstants.primaryColor,
//                     backgroundColor: AppConstants.surfaceColor,
//                     onSelected: (bool selected) {
//                       ref.read(selectedCategoryProvider.notifier).state = category;
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//           Expanded(
//             child: filteredState.when(
//               data: (venues) {
//                 if (venues.isEmpty) {
//                   return const Center(
//                     child: Text(
//                       "Bu kategoride mekan bulunamadı :/",
//                       style: TextStyle(color:AppConstants.secondaryColor, fontSize: 16),
//                     ),
//                   );
//                 }
//                 return Padding(
//                   padding: const EdgeInsets.only(
//                     left: AppConstants.defaultPadding,
//                     right: AppConstants.defaultPadding,
//                     top: AppConstants.defaultPadding,
//                     bottom: 3
//                   ),
//                   child: ListView.builder(
//                     itemCount: venues.length,
//                     itemBuilder: (context, index) => VenueCard(venue: venues[index]),
//                   ),
//                 );
//               },
//               loading: () => const VenueShimmerList(),
//               error: (error, stackTrace) => Center(
//                 child: Text(
//                   "Tabancanın ucu kopti: $error",
//                   style: const TextStyle(color: AppConstants.errorColor),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';
import '../widgets/venue_shimmer_list.dart';
import '../../../events/presentations/widgets/events_list_view.dart';
import 'package:geocoding/geocoding.dart';
import '../providers/city_search_provider.dart';

final List<String> _categories = ["Tümü", "Rock Bar", "Pub", "Canlı Müzik", "Metal"];

// 1. ŞALTERİMİZ: Eğer events_providers.dart içine eklemediysen, geçici olarak buraya da koyabilirsin.
// Ama ideali events_providers.dart içinde olmasıdır.
final isEventViewProvider = StateProvider<bool>((ref) => false);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Şalteri ve mevcut mekan verilerini dinliyoruz
    final isEventView = ref.watch(isEventViewProvider);
    final filteredState = ref.watch(filteredVenuesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          isEventView ? "Yaklaşan Konserler" : AppConstants.appName,
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppConstants.primaryColor, size: 28),
            onPressed: () => _showCitySearchDialog(context, ref),
            tooltip: "Şehir Ara",
          ),
          // 2. GİT-GEL BUTONUMUZ
          IconButton(
            icon: Icon(
              isEventView ? Icons.storefront_outlined : Icons.local_play_rounded,
              color: AppConstants.primaryColor,
              size: 28,
            ),
            onPressed: () {
              // Butona basınca şalterin yönünü değiştiriyoruz
              ref.read(isEventViewProvider.notifier).state = !isEventView;
            },
            tooltip: isEventView ? "Mekanlara Dön" : "Konserleri Gör",
          ),
          const SizedBox(width: 8),
        ],
      ),
      
      // 3. DİNAMİK GÖVDE: Şalter true ise Konserler, false ise Senin Mekanlar Listen
      body: isEventView
          ? const EventsListView() // Ticketmaster Listesi
          : Column(
              // Senin Google Places Mekanlar Listen ve Kategori Çiplerin
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.black : AppConstants.textPrimary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                            ),
                          ),
                          selected: isSelected,
                          selectedColor: AppConstants.primaryColor,
                          backgroundColor: AppConstants.surfaceColor,
                          onSelected: (bool selected) {
                            ref.read(selectedCategoryProvider.notifier).state = category;
                          },
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: filteredState.when(
                    data: (venues) {
                      if (venues.isEmpty) {
                        return const Center(
                          child: Text(
                            "Bu kategoride mekan bulunamadı :/",
                            style: TextStyle(color: AppConstants.secondaryColor, fontSize: 16),
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(
                          left: AppConstants.defaultPadding,
                          right: AppConstants.defaultPadding,
                          top: AppConstants.defaultPadding,
                          bottom: 3
                        ),
                        child: ListView.builder(
                          itemCount: venues.length,
                          itemBuilder: (context, index) => VenueCard(venue: venues[index]),
                        ),
                      );
                    },
                    loading: () => const VenueShimmerList(),
                    error: (error, stackTrace) => Center(
                      child: Text(
                        "Tabancanın ucu kopti: $error",
                        style: const TextStyle(color: AppConstants.errorColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}

// Şehir arama penceresini (Dialog) gösteren fonksiyon
  Future<void> _showCitySearchDialog(BuildContext context, WidgetRef ref) async {
    final TextEditingController cityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppConstants.surfaceColor,
          title: const Text("Şehir Değiştir", style: TextStyle(color: AppConstants.textPrimary)),
          content: TextField(
            controller: cityController,
            style: const TextStyle(color: AppConstants.textPrimary),
            decoration: const InputDecoration(
              hintText: "Örn: Bursa, Kadıköy...",
              hintStyle: const TextStyle(color: AppConstants.textSecondary),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppConstants.primaryColor)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppConstants.primaryColor)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("İptal", style: TextStyle(color: AppConstants.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final cityName = cityController.text.trim();
                if (cityName.isNotEmpty) {
                  try {
                    // Geocoding paketi ile şehir adını koordinata çeviriyoruz
                    List<Location> locations = await locationFromAddress(cityName);
                    if (locations.isNotEmpty) {
                      final lat = locations.first.latitude;
                      final lng = locations.first.longitude;
                      
                      // Riverpod hafızasını yeni şehirle güncelliyoruz!
                      ref.read(selectedCityProvider.notifier).state = CityLocation(lat, lng, cityName);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Şehir bulunamadı, lütfen tekrar deneyin.')),
                    );
                  }
                }
                if (context.mounted) Navigator.pop(context); // Kutuyu kapat
              },
              child: const Text("Ara"),
            ),
          ],
        );
      },
    );
  }