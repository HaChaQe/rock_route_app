import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/ticketmaster_service.dart';
import '../../../venues/presentation/providers/location_provider.dart'; // Senin konum provider'ının yolu
import '../../data/models/event_model.dart';
import '../../../venues/presentation/providers/city_search_provider.dart';


// false = Mekanlar Ekranı, true = Konserler Ekranı
final isEventViewProvider = StateProvider<bool>((ref) => false);

// 1. Servisimizi Riverpod ekosistemine tanıtıyoruz (Dependency Injection)
final ticketmasterServiceProvider = Provider<TicketmasterService>((ref) {
  return TicketmasterService();
});

// 2. Etkinlikleri çeken asıl Asenkron Provider
final eventsProvider = FutureProvider<List<EventModel>>((ref) async {

 // 1. Önce kullanıcının yukarıdaki arama çubuğundan bir şehir arayıp aramadığına bakıyoruz
  final selectedCity = ref.watch(selectedCityProvider);
  
  double lat;
  double lng;

  if (selectedCity != null) {
    // KULLANICI ARAMA YAPMIŞ! Haritayı ve etkinlikleri o şehre ışınlıyoruz.
    lat = selectedCity.latitude;
    lng = selectedCity.longitude;
  } else {
    // ARAMA YAPILMAMIŞ! O zaman standart GPS konumumuzu dinlemeye devam ediyoruz.
    final locationAsyncValue = ref.watch(currentLocationProvider);
    final position = locationAsyncValue.value;
    
    // Konum henüz yüklenmediyse veya hata verdiyse API'yi boşuna yormuyoruz
    if (position == null) {
      return []; 
    }
    
    lat = position.latitude;
    lng = position.longitude;
  }

  // Servisimizi çağırıyoruz
  final service = ref.read(ticketmasterServiceProvider);
  
  // Belirlenen koordinatlara göre modern rock ve metal konserlerini çekiyoruz
  return await service.fetchRockEvents(lat, lng);
});