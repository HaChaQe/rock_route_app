import '../models/venue_model.dart';
import '../../../../core/services/google_places_service.dart';

// class VenueRepository {
//   Future<List<VenueModel>> getVenues() async{
//     await Future.delayed(const Duration(milliseconds: 1500));
//     return [
//       VenueModel(
//         id: "1",
//         name: "Chaash Rock Cafe",
//         description: "Dio müritleri yolda geliyo (9 tır)",
//         imageUrl: "assets/images/img1.jpg",
//         latitude: 36.7725,
//         longitude: 34.5810,
//         rating: 5,
//         category: "Legend"
//       ),
//       VenueModel(
//         id: "2",
//         name: "Dark Tale DIO",
//         description: "Primeish era of DIO",
//         imageUrl: "assets/images/img4.webp",
//         latitude: 36.7845,
//         longitude: 34.5912,
//         rating: 4.8,
//         category: "Metal"
//       ),
//         VenueModel(
//         id: "3",
//         name: "Dio Prime",
//         description: "Real prime era of DIO",
//         imageUrl: "assets/images/img2.png",
//         latitude: 36.7901,
//         longitude: 34.5975,
//         rating: 4.8,
//         category: "Metal"
//       ),
//       VenueModel(
//         id: "4",
//         name: "Dio Disciples",
//         description: "Müritler yolda geliyo (9 tır)",
//         imageUrl: "assets/images/img1.jpg",
//         latitude: 36.7458,
//         longitude: 34.5421,
//         rating: 4.8,
//         category: "Metal"
//       ),
//       VenueModel(
//         id: "5",
//         name: "DIO by Dio",
//         description: "Anlatmaya gerek yok :)",
//         imageUrl: "assets/images/img3.jpeg",
//         latitude: 36.7984,
//         longitude: 34.6155,
//         rating: 4.8,
//         category: "Metal"
//       ),
//     ];
//   }
// }

class VenueRepository {
  final GooglePlacesService _placesService;

  VenueRepository({required GooglePlacesService placesService})
      : _placesService = placesService;

  Future<List<VenueModel>> getVenues(double lat, double lng) async {
    try {
      // Bütün ağır yükü (JSON parsing, fotoğraf linki, kategori vs.) 
      // zaten GooglePlacesService içindeki 'getNearbyVenues' yapıyor.
      // Biz sadece o tertemiz listeyi alıp Provider'a iletiyoruz!
      return await _placesService.getNearbyVenues(lat, lng);
      
    } catch (e) {
      print("REPOSITORY HATASI: $e");
      return []; // Hata olursa uygulamayı çökertmemek için boş liste dönüyoruz
    }
  }
}