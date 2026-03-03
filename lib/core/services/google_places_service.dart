// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/venues/data/models/venue_model.dart'; 

class GooglePlacesService {
  final Dio _dio;
  
  // Google'ın Mekan Arama Adresi
  final String _baseUrl = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  GooglePlacesService() : _dio = Dio();

  Future<List<VenueModel>> getNearbyVenues(double lat, double lng) async {
    try {
      // 🔐 Şifreyi güvenlik kasasından (Dart dünyasından) çekiyoruz!
      final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? '';
      print('🔑 Kasadan Çıkan Anahtar: $apiKey');
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'location': '$lat,$lng', // Enlem ve Boylam
          'rankby': 'distance', // 5 Kilometre yarıçapında ara
          // 'type': 'bar', // Sadece barları getir
          'keyword': '(rock OR metal OR canlı müzik OR sahne OR pub OR concert) AND rock bar pub',
          'key': apiKey, // Kasadan çıkan şifre
        },
      );

      print('🌍 Google Cevabı: ${response.data}');


      final List results = response.data['results'] ?? [];
      
      return results.map((json) {

        String imageUrl = 'https://via.placeholder.com/400x300?text=Resim+Yok';

        if (json['photos'] != null && (json['photos'] as List).isNotEmpty) {
          // 1. Buradaki ismin 'photo_reference' olduğundan emin ol (alt tire önemli)
          final String photoRef = json['photos'][0]['photo_reference'];
          final String apiKey = dotenv.env['GOOGLE_API_KEY'] ?? ''; 
          
          // 2. URL'yi parçalara bölelim ki hata payı kalmasın
          const String photoBaseUrl = 'https://maps.googleapis.com/maps/api/place/photo';
          const int maxWidth = 400;
          
          imageUrl = '$photoBaseUrl?maxwidth=$maxWidth&photoreference=$photoRef&key=$apiKey';
          
          // 🕵️‍♂️ AJAN KOD: Konsola tıkla bak bakalım URL doğru mu?
          print('🖼️ FOTO URL: $imageUrl');
        }

        // 🌟 Google puanları zaten 5 üzerindendir, 2'ye bölmeye gerek yok!
        double rating = (json['rating'] ?? 0.0).toDouble();

        // 🏷️ Kategoriyi dinamik yapalım
        String venueNameUpper = (json['name'] ?? '').toString().toUpperCase();
        String rawTypes = (json['types'] as List).join(' ').toUpperCase();

        String displayCategory = "Pub";

        if (venueNameUpper.contains('METAL')) {
          displayCategory = "Metal";
        } 
        // İsmi direkt Rock Bar olanlar
        else if (venueNameUpper.contains('ROCK')) {
          displayCategory = "Rock Bar";
        } 
        // Canlı Müzik / Sahne konsepti olanlar (İsminde sahne/performans geçenler veya gece kulübü ruhsatlı barlar genelde sahneli olur)
        else if (venueNameUpper.contains('SAHNE') || venueNameUpper.contains('PERFORMANS') || venueNameUpper.contains('CANLI') || rawTypes.contains('NIGHT_CLUB')) {
          displayCategory = "Canlı Müzik";
        } 
        // Klasik Pub ve Barlar
        else if (venueNameUpper.contains('PUB') || rawTypes.contains('BAR')) {
          displayCategory = "Pub";
        } 
        // Yukarıdakilerin hiçbirine uymayanları genel konsepte dahil edelim
        else {
          displayCategory = "Rock Bar"; 
        }

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