import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Senin modelinin yolunu kendi klasörüne göre düzeltmeyi unutma!
import '../../features/venues/data/models/venue_model.dart'; 

class GooglePlacesService {
  final Dio _dio;
  
  // Google'ın Mekan Arama Adresi
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  GooglePlacesService() : _dio = Dio();

  Future<List<VenueModel>> getNearbyVenues(double lat, double lng) async {
    try {
      // 🔐 Şifreyi güvenlik kasasından (Dart dünyasından) çekiyoruz!
      final String apiKey = dotenv.env['MAPS_API_KEY'] ?? '';
      print('🔑 Kasadan Çıkan Anahtar: $apiKey');
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'location': '$lat,$lng', // Enlem ve Boylam
          'radius': 5000, // 5 Kilometre yarıçapında ara
          'type': 'bar', // Sadece barları getir
          'keyword': 'rock bar pub', // ✨ Senin tarzına özel arama kelimesi!
          'key': apiKey, // Kasadan çıkan şifre
        },
      );

      print('🌍 Google Cevabı: ${response.data}');


      final List results = response.data['results'] ?? [];
      
      return results.map((json) {
        
        // 📸 Google'dan Fotoğraf Çekmek (Foursquare'den daha farklıdır)
        // String imageUrl = 'https://via.placeholder.com/400x300?text=Fotoğraf+Yok';
        // if (json['photos'] != null && (json['photos'] as List).isNotEmpty) {
        //   final photoRef = json['photos'][0]['photo_reference'];
        //   // Google resimleri doğrudan bir URL parametresiyle verir
        //   imageUrl = 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=$photoRef&key=$apiKey';
        // }
        // 📸 Google Fotoğraf URL'sini Jilet Gibi Yapalım
        // 📸 Google Fotoğraf URL'sini Jilet Gibi Yapalım
        String imageUrl = 'https://via.placeholder.com/400x300?text=Resim+Yok';

        if (json['photos'] != null && (json['photos'] as List).isNotEmpty) {
          // 1. Buradaki ismin 'photo_reference' olduğundan emin ol (alt tire önemli)
          final String photoRef = json['photos'][0]['photo_reference'];
          final String apiKey = dotenv.env['MAPS_API_KEY'] ?? ''; 
          
          // 2. URL'yi parçalara bölelim ki hata payı kalmasın
          const String photoBaseUrl = 'https://maps.googleapis.com/maps/api/place/photo';
          const int maxWidth = 400;
          
          imageUrl = '$photoBaseUrl?maxwidth=$maxWidth&photo_reference=$photoRef&key=$apiKey';
          
          // 🕵️‍♂️ AJAN KOD: Konsola tıkla bak bakalım URL doğru mu?
          print('🖼️ FOTO URL: $imageUrl');
        }

        // 🌟 Google puanları zaten 5 üzerindendir, 2'ye bölmeye gerek yok!
        double rating = (json['rating'] ?? 0.0).toDouble();

        // 🏷️ Kategoriyi dinamik yapalım
        String rawCategory = (json['types'] as List).isNotEmpty 
            ? json['types'][0].toString().replaceAll('_', ' ').toUpperCase() 
            : 'ROCK VENUE';

        // Eğer senin "Modern Rock" tarzına sadık kalsın istiyorsan:
        String displayCategory = rawCategory.contains('BAR') ? 'MODERN ROCK BAR' : rawCategory;



        return VenueModel(
          id: json['place_id'] ?? '',
          name: json['name'] ?? 'İsimsiz Mekan',
          // category: 'Modern Rock Bar', // Google net kategori vermez, konseptimizi biz basıyoruz
          category: displayCategory,
          rating: rating,
          latitude: json['geometry']['location']['lat'],
          longitude: json['geometry']['location']['lng'],
          imageUrl: imageUrl,
          description: json['vicinity'] ?? 'Mekan adresi bulunamadı.', // Google adresi "vicinity" içinde tutar
        );
      }).toList();

    } catch (e) {
      throw Exception('🔥 Google Places Patladı: $e');
    }
  }
}