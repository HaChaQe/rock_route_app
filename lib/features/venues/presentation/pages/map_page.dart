import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../events/presentations/widgets/event_detail_sheet.dart';
import '../providers/city_search_provider.dart'; 

import 'package:rock_route/features/venues/presentation/providers/venue_provider.dart';
import 'package:rock_route/features/venues/presentation/providers/location_provider.dart';
import 'package:rock_route/features/venues/presentation/widgets/venue_detail_sheet.dart';
import 'package:rock_route/features/events/presentations/providers/events_providers.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  GoogleMapController? _mapController;

  // 🤘 SENIOR DOKUNUŞU: RockRoute Özel Karanlık Harita Teması
  static const String _darkMapStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [{"color": "#212121"}]
    },
    {
      "elementType": "labels.icon",
      "stylers": [{"visibility": "off"}]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#212121"}]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "administrative.country",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#9e9e9e"}]
    },
    {
      "featureType": "administrative.locality",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#bdbdbd"}]
    },
    {
      "featureType": "poi",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "geometry",
      "stylers": [{"color": "#181818"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text.stroke",
      "stylers": [{"color": "#1b1b1b"}]
    },
    {
      "featureType": "road",
      "elementType": "geometry.fill",
      "stylers": [{"color": "#2c2c2c"}]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#8a8a8a"}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "geometry",
      "stylers": [{"color": "#373737"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "geometry",
      "stylers": [{"color": "#3c3c3c"}]
    },
    {
      "featureType": "road.highway.controlled_access",
      "elementType": "geometry",
      "stylers": [{"color": "#4e4e4e"}]
    },
    {
      "featureType": "road.local",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#616161"}]
    },
    {
      "featureType": "transit",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#757575"}]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [{"color": "#000000"}]
    },
    {
      "featureType": "water",
      "elementType": "labels.text.fill",
      "stylers": [{"color": "#3d3d3d"}]
    }
  ]
  ''';

  static const CameraPosition _mersinCenter = CameraPosition(
    target: LatLng(36.7783, 34.6415),
    zoom: 14.4746
  );

  @override
  Widget build(BuildContext context) {
    final venueState = ref.watch(venueProvider);
    final locationState = ref.watch(currentLocationProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    final eventState = ref.watch(eventsProvider); 

    // Şehir değiştiğinde kamerayı uçur
    ref.listen(selectedCityProvider, (previous, next) {
      if (next != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(next.latitude, next.longitude), 14.5),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("RockRoute Harita", style: TextStyle(color: AppConstants.primaryColor,fontWeight: FontWeight.bold)),
      ),
      body: venueState.when(
        error: (err, stack) => Center(child: Text("Hata $err")),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (venues) {
          
          final Set<Marker> markers = {};

          // 🎸 1. MEKANLAR: KLASİK MOR PİNLER (Violet)
          final venueMarkers = venues.map((venue){
            return Marker(
              markerId: MarkerId('venue_${venue.id}'),
              position: LatLng(venue.latitude, venue.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                HSVColor.fromColor(AppConstants.primaryColor).hue, // Rengini Hue'ya çevirir!
              ),
              onTap: () {
                showVenueDetailSheet(context, venue);
              },
            );
          }).toSet(); 
          markers.addAll(venueMarkers);

          // 🎤 2. KONSERLER: TURUNCU PİNLER (Orange) - Uyumlu ve Dikkat Çekici!
          if (eventState.hasValue && eventState.value != null) {
            final eventMarkers = eventState.value!.map((event) {
              
              // Type Promotion ile güvenli atama (Ünlem işaretinden kurtulduk!)
              final lat = event.latitude;
              final lng = event.longitude;

              if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
                return null;
              }

              return Marker(
                markerId: MarkerId('event_${event.id}'),
                position: LatLng(lat, lng),
                // Boyut ve gölge mekanlarla birebir aynı, sadece rengi Turuncu
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  HSVColor.fromColor(AppConstants.secondaryColor).hue, // Rengini Hue'ya çevirir!
                ),
                onTap: () {
                  showEventDetailSheet(context, event);
                },
              );
            }).whereType<Marker>().toSet(); 
            
            markers.addAll(eventMarkers);
          }

          // Kamera başlangıç pozisyonu
          CameraPosition initialCamera;
          if (selectedCity != null) {
            initialCamera = CameraPosition(
              target: LatLng(selectedCity.latitude, selectedCity.longitude),
              zoom: 14.5
            );
          } else if (locationState.value != null) {
            initialCamera = CameraPosition(
              target: LatLng(locationState.value!.latitude, locationState.value!.longitude),
              zoom: 14.5
            );
          } else {
            initialCamera = _mersinCenter;
          }

          return GoogleMap(
            mapType: MapType.normal,
            style: _darkMapStyle,
            initialCameraPosition: initialCamera,
            markers: markers,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
          );
        },
      ),
    );
  }
}