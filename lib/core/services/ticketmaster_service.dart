import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/events/data/models/event_model.dart';

class TicketmasterService {
  final Dio _dio = Dio();
  // Ticketmaster'ın konserleri listelediği ana endpoint'i
  final String _baseUrl = 'https://app.ticketmaster.com/discovery/v2/events.json';

  Future<List<EventModel>> fetchRockEvents(double lat, double lng) async {
    try {
      // 1. Şifreyi kasadan alıyoruz
      final apiKey = dotenv.env['TICKETMASTER_API_KEY'];
      if (apiKey == null) throw Exception('Ticketmaster API Key bulunamadı!');

      // 2. Dio ile HTTP GET isteğimizi atıyoruz
      final response = await _dio.get(_baseUrl, queryParameters: {
        'apikey': apiKey,
        'latlong': '$lat,$lng',
        'radius': '50', // Seçili konuma 50 km çapındaki etkinlikler
        'unit': 'km',
        'classificationName': 'Rock,Metal', 
        'sort': 'date,asc', // En yakın tarihliden en uzağa doğru sırala
      });

      // 3. Ticketmaster'ın iç içe geçmiş (nested) JSON'unu ayıklama operasyonu
      // Ticketmaster verileri her zaman "_embedded" adlı bir paketin içinde yollar.
      if (response.data['_embedded'] != null && response.data['_embedded']['events'] != null) {
        final List eventsJson = response.data['_embedded']['events'];

        // 4. Gelen karmaşık listeyi bizim temiz EventModel listesine çeviriyoruz (Mapping)
        return eventsJson.map((json) {
          
          // Afiş url'sini güvenle çıkar (Yoksa boş dönsün)
          String imageUrl = '';
          if (json['images'] != null && json['images'].isNotEmpty) {
            imageUrl = json['images'][0]['url']; // İlk afişi alıyoruz
          }

          // Mekan adını "_embedded.venues" içinden derin bir kazıyla çıkar
          String venueName = 'Bilinmeyen Mekan';
          if (json['_embedded'] != null && 
              json['_embedded']['venues'] != null && 
              json['_embedded']['venues'].isNotEmpty) {
            venueName = json['_embedded']['venues'][0]['name'];
          }

          // Tarihi çıkar
          String date = json['dates']?['start']?['localDate'] ?? 'Tarih Belirsiz';
          
          // Bilet linkini çıkar
          String ticketUrl = json['url'] ?? '';

          // 5. Ayıkladığımız bu temiz verileri EventModel'imize veriyoruz!
          return EventModel.fromJson({
            'id': json['id'] ?? '',
            'name': json['name'] ?? 'Bilinmeyen Etkinlik',
            'ticketUrl': ticketUrl,
            'imageUrl': imageUrl,
            'date': date,
            'venueName': venueName,
          });
        }).toList();
      }

      // Eğer o bölgede hiç etkinlik yoksa boş liste dönüyoruz, uygulamayı çökertmiyoruz.
      return []; 
    } catch (e) {
      print('Ticketmaster Veri Çekme Hatası: $e');
      return [];
    }
  }
}