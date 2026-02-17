import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref){
  throw UnimplementedError();
});

class FavoritesNotifier extends StateNotifier<List<String>> {
  final SharedPreferences prefs;
  static const _key = 'favorite_venue_ids';

  FavoritesNotifier(this.prefs) : super([]){
    _loadFavorites();
  }
  
  void _loadFavorites() {
    final saved = prefs.getStringList(_key) ?? [];
    state = saved;
  }

  void toggleFavorite(String venueId){ // Ekle - Çıkar
    if (state.contains(venueId)) { // zaten varsa çıkar
      state = state.where((id) => id != venueId).toList();
    }else {
      state = [...state, venueId];//yoksa ekle
    }

    prefs.setStringList(_key, state); //kaydet
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FavoritesNotifier(prefs);
});