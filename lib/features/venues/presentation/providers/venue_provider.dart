import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/venue_model.dart';
import '../../data/repositories/venue_repository.dart';
import '../../../../core/services/google_places_service.dart';


final googlePlacesServiceProvider = Provider<GooglePlacesService>((ref){
  return GooglePlacesService();
});

final venueRepositoryProvider = Provider<VenueRepository>((ref){
  final googleService = ref.read(googlePlacesServiceProvider);
  return VenueRepository(googlePlacesService: googleService);
});

final venueProvider = AsyncNotifierProvider<VenueNotifier, List<VenueModel>>((){
  return VenueNotifier();
});

class VenueNotifier extends AsyncNotifier<List<VenueModel>> {

  @override
  Future<List<VenueModel>> build() async {
    final repository = ref.read(venueRepositoryProvider);
    const double testlat = 36.7845;
    const double testlng = 34.5912;
    return repository.getVenues(testlat, testlng);
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