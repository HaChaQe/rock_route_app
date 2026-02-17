import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permision;

    //Servis kontrol
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Konum servisleri kapalı. Lütfen konumu açın.");
    }

    //Konum izni
    permision = await Geolocator.checkPermission();
    if (permision == LocationPermission.denied) {
      permision = await Geolocator.requestPermission();
      if (permision == LocationPermission.denied) {
        return Future.error("Konum izni reddedildi.");
      }
    }

    if (permision == LocationPermission.deniedForever) {
      return Future.error("Konum izni kalıcı olarak reddedildi. Telefon ayarlarından açın");
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high
      )
    );
  }
}