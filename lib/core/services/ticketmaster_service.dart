import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Kendi proje yoluna göre burayı kontrol etmeyi unutma:
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
        'size': '30',
      });

      // 3. Ticketmaster'ın iç içe geçmiş (nested) JSON'unu ayıklama operasyonu
      if (response.data['_embedded'] != null && response.data['_embedded']['events'] != null) {
        final List eventsJson = response.data['_embedded']['events'];

        // 🤘 AJAN 1: Bize API'den kaç konser gelmiş?
        print("🎸 Ticketmaster'dan gelen HAM konser sayısı: ${eventsJson.length}");

        // 🤘 SENIOR DOKUNUŞU: HİBRİT VE ACIMASIZ FİLTRE (Fedai Modu)
        final filteredEvents = eventsJson.where((json) {
          final eventName = (json['name'] ?? '').toString().toLowerCase();

          // --- 1. GÜVENLİK DUVARI: ACIMASIZ KARA LİSTE ---
          final blacklist = [
            '90', '80', 'pop', 'arabesk', 'türkü', 'dj ', 'club', 'kop', 
            'stand up', 'stand-up', 'tiyatro', 'komedi', 'rap', 'parti', 'party',
            'hip hop', 'gazino', 'meyhane', 'fasıl', 'tribute', 'cover',
            'ferhat', 'göçer', 'serdar', 'ortaç', 'yıldız', 'tilbe'
          ];
          
          for (var badWord in blacklist) {
            if (eventName.contains(badWord)) {
              return false; // Kara listede var, ANINDA REDDET!
            }
          }

          // --- 2. GÜVENLİK DUVARI: KESİN TÜR KONTROLÜ (Whitelist) ---
          bool isRockOrMetal = false;
          
          // Belki adamlar tür girmemiştir ama adında rock geçiyordur:
          if (eventName.contains('rock') || eventName.contains('metal') || eventName.contains('punk')) {
            isRockOrMetal = true;
          }

          if (json['classifications'] != null && json['classifications'].isNotEmpty) {
            final genre = (json['classifications'][0]['genre']?['name'] ?? '').toString().toLowerCase();
            final subGenre = (json['classifications'][0]['subGenre']?['name'] ?? '').toString().toLowerCase();

            if (genre.contains('rock') || genre.contains('metal') || 
                subGenre.contains('rock') || subGenre.contains('metal') ||
                genre.contains('alternative') || genre.contains('alternatif') || 
                genre.contains('punk')) {
              isRockOrMetal = true;
            }
          }

          // Sadece her iki duvarı da aşabilen safkan etkinlikler listeye girebilir!
          // NOT: Eğer listen inatla BOŞ geliyorsa, sorunun filtrede olup olmadığını anlamak için 
          // geçici olarak burayı "return true;" yapıp test edebilirsin.
          return isRockOrMetal;
        }).toList();

        // 🤘 AJAN 2: Filtremizden kaç kişi sağ çıktı?
        print("🤘 Filtreden SAĞ ÇIKAN konser sayısı: ${filteredEvents.length}");

        // 4. Gelen karmaşık listeyi bizim temiz EventModel listesine çeviriyoruz (Mapping)
        return filteredEvents.map((json) {
          
          // Afiş url'sini güvenle çıkar (Yoksa boş dönsün)
          String imageUrl = '';
          if (json['images'] != null && json['images'].isNotEmpty) {
            imageUrl = json['images'][0]['url']; // İlk afişi alıyoruz
          }

          // Mekan adını VE KOORDİNATLARINI derin bir kazıyla çıkar
          String venueName = 'Bilinmeyen Mekan';
          double? eventLat;
          double? eventLng;

          if (json['_embedded'] != null && 
              json['_embedded']['venues'] != null && 
              json['_embedded']['venues'].isNotEmpty) {
            
            final venueData = json['_embedded']['venues'][0];
            venueName = venueData['name'] ?? 'Bilinmeyen Mekan';
            
            // İşte eksik olan o kritik koordinat çekme operasyonu!
            if (venueData['location'] != null) {
              eventLat = double.tryParse(venueData['location']['latitude']?.toString() ?? '');
              eventLng = double.tryParse(venueData['location']['longitude']?.toString() ?? '');
            }
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
            'latitude': eventLat ?? 0.0,
            'longitude': eventLng ?? 0.0, // DİKKAT: 'longtitude' DEĞİL, 'longitude'
          });
        }).toList();
      }

      // Eğer o bölgede hiç etkinlik yoksa boş liste dönüyoruz, uygulamayı çökertmiyoruz.
      return []; 
    } catch (e) {
      // ignore: avoid_print
      print('Ticketmaster Veri Çekme Hatası: $e');
      return [];
    }
  }
}