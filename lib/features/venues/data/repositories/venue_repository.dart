import '../models/venue_model.dart';

class VenueRepository {
  Future<List<VenueModel>> getVenues() async{
    await Future.delayed(const Duration(milliseconds: 1500));
    return [
      VenueModel(
        id: "1",
        name: "Chaash Rock Cafe",
        description: "Dio müritleri yolda geliyo (9 tır)",
        imageUrl: "assets/images/img1.jpg",
        latitude: 36.7783,
        longitude: 34.6415,
        rating: 5,
        category: "Legend"
      ),
      VenueModel(
        id: "2",
        name: "Dio Disciples",
        description: "Dio müritleri yolda geliyo (9 tır)",
        imageUrl: "assets/images/img1.jpg",
        latitude: 36.7783,
        longitude: 34.6415,
        rating: 4.8,
        category: "Metal"
      ),
      VenueModel(
        id: "3",
        name: "Dio Disciples",
        description: "Dio müritleri yolda geliyo (9 tır)",
        imageUrl: "assets/images/img1.jpg",
        latitude: 36.7783,
        longitude: 34.6415,
        rating: 4.8,
        category: "Metal"
      ),
      VenueModel(
        id: "4",
        name: "Dio Disciples",
        description: "Dio müritleri yolda geliyo (9 tır)",
        imageUrl: "assets/images/img1.jpg",
        latitude: 36.7783,
        longitude: 34.6415,
        rating: 4.8,
        category: "Metal"
      ),
      VenueModel(
        id: "5",
        name: "Dio Disciples",
        description: "Dio müritleri yolda geliyo (9 tır)",
        imageUrl: "assets/images/img1.jpg",
        latitude: 36.7783,
        longitude: 34.6415,
        rating: 4.8,
        category: "Metal"
      ),
    ];
  }
}