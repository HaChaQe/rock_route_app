import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/venue_model.dart';
import '../../data/repositories/venue_repository.dart';

final venueRepositoryProvider = Provider<VenueRepository>((ref){
  return VenueRepository();
});

final venueProvider = AsyncNotifierProvider<VenueNotifier, List<VenueModel>>((){
  return VenueNotifier();
});

class VenueNotifier extends AsyncNotifier<List<VenueModel>> {

  @override
  Future<List<VenueModel>> build() async {
    final repository = ref.read(venueRepositoryProvider);
    return repository.getVenues();
  }
}