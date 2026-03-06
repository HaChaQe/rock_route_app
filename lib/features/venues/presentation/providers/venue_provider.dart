import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/venue_model.dart';
import '../../data/repositories/venue_repository.dart';
import '../../../../core/services/google_places_service.dart';
import 'city_search_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'location_provider.dart';

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

// location_provider'ını import etmeyi unutma!

class VenueNotifier extends AsyncNotifier<List<VenueModel>> {
  @override
  Future<List<VenueModel>> build() async {
    final repository = ref.read(venueRepositoryProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    
    // 🤘 1. GERÇEK GPS'İ DİNLİYORUZ!
    final locationAsync = ref.watch(currentLocationProvider); 

    double lat;
    double lng;

    if (selectedCity != null) {
      // Arama yapıldıysa o şehri kullan
      lat = selectedCity.latitude;
      lng = selectedCity.longitude;
    } else {
      // ARAMA YOKSA SABİT KOORDİNAT YERİNE GERÇEK GPS'İ KULLAN!
      final currentPosition = locationAsync.value;
      if (currentPosition != null) {
        lat = currentPosition.latitude;
        lng = currentPosition.longitude;
      } else {
        return []; // GPS henüz gelmediyse boş liste dön (veya loading göster)
      }
    }

    // 2. Veriyi çek
    final venues = await repository.getVenues(lat, lng);

    // 3. Mesafe sıralamasını (artık gerçek GPS'e veya Aranan Şehre göre) yap!
    venues.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(lat, lng, a.latitude, a.longitude);
      final distanceB = Geolocator.distanceBetween(lat, lng, b.latitude, b.longitude);
      return distanceA.compareTo(distanceB); 
    });

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