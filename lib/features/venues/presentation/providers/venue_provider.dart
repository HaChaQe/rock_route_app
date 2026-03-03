import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/venue_model.dart';
import '../../data/repositories/venue_repository.dart';
import '../../../../core/services/google_places_service.dart';
import 'city_search_provider.dart';
import 'package:geolocator/geolocator.dart';

// Google servisimizi Provider'a ekliyoruz
final googlePlacesServiceProvider = Provider<GooglePlacesService>((ref){
  return GooglePlacesService();
});

// Repository'e Google servisini veriyoruz
final venueRepositoryProvider = Provider<VenueRepository>((ref) {
  final placesService = ref.read(googlePlacesServiceProvider);
  return VenueRepository(placesService: placesService);
}); 

final venueProvider = AsyncNotifierProvider<VenueNotifier, List<VenueModel>>((){
  return VenueNotifier();
});

class VenueNotifier extends AsyncNotifier<List<VenueModel>> {

  @override
  Future<List<VenueModel>> build() async {
    final repository = ref.read(venueRepositoryProvider);
    final selectedCity = ref.watch(selectedCityProvider);

    double lat;
    double lng;

    if (selectedCity != null) {
      lat = selectedCity.latitude;
      lng = selectedCity.longitude;
    } else {
      // Varsayılan Konum (Mersin)
      lat = 36.7845;
      lng = 34.5912;
    }

    // 1. API'den mekanları çekiyoruz (Burada hala Google'ın karışık sırasında geliyorlar)
    final venues = await repository.getVenues(lat, lng);

    // 🤘 2. SENIOR DOKUNUŞU: Listeyi havada yakalayıp merkeze olan uzaklığa göre diziyoruz!
    venues.sort((a, b) {
      // Not: Kendi VenueModel'indeki değişken adlarına göre 'a.lat' veya 'a.latitude' olarak düzeltmeyi unutma!
      final distanceA = Geolocator.distanceBetween(lat, lng, a.latitude, a.longitude);
      final distanceB = Geolocator.distanceBetween(lat, lng, b.latitude, b.longitude);
      
      // Yakından (küçük mesafe) uzağa (büyük mesafe) doğru sırala
      return distanceA.compareTo(distanceB); 
    });

    // 3. Jilet gibi sıralanmış listeyi arayüze gönder!
    return venues;
  }
}

final selectedCategoryProvider = StateProvider<String>((ref) => "Tümü");

final filteredVenuesProvider = Provider<AsyncValue<List<VenueModel>>>((ref) {
  // 1. Tüm mekanların listesini dinle
  final allVenuesAsync = ref.watch(venueProvider);
  // 2. Seçili olan kategoriyi dinle
  final selectedCategory = ref.watch(selectedCategoryProvider);

  // 3. Veriler yüklendiğinde filtreleme işlemini yap
  return allVenuesAsync.whenData((venues) {
    if (selectedCategory == 'Tümü') {
      return venues; // Filtre yoksa hepsini gönder
    }
    // Sadece kategorisi seçilene eşit olanları süz
    return venues.where((v) => v.category == selectedCategory).toList();
  });
});