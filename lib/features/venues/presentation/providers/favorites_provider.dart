import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rock_route/features/venues/data/models/venue_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<VenueModel>>((ref){
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<List<VenueModel>>{
  FavoritesNotifier() : super([]) {
    _loadFavorites();
  }

  static const _storageKey = 'rock_route_full_favorites';

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_storageKey) ?? [];
    final venues = jsonList.map((jsonStr) => VenueModel.fromJson(jsonDecode(jsonStr))).toList();
    state = venues;
  }

  Future<void> toggleFavorite(VenueModel venue) async {
    final prefs = await SharedPreferences.getInstance();
    final isFavorite = state.any((v) => v.id == venue.id);

    if (isFavorite) {
      state = state.where((v) => v.id != venue.id).toList();
    }else{
      state = [...state, venue];
    }

    final jsonList = state.map((v) => jsonEncode(v.toJson())).toList();
    await prefs.setStringList(_storageKey, jsonList);
  }

  bool isFavorite(String venueId) {
    return state.any((v) => v.id == venueId);
  }

}