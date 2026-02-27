import 'package:flutter_riverpod/flutter_riverpod.dart';

// Sadece enlem, boylam ve şehir adını tutan basit bir model
class CityLocation {
  final double latitude;
  final double longitude;
  final String cityName;

  CityLocation(this.latitude, this.longitude, this.cityName);
}

// Başlangıçta null. Kullanıcı arama yapınca burası dolacak.
final selectedCityProvider = StateProvider<CityLocation?>((ref) => null);