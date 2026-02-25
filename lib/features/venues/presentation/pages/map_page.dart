import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:rock_route/features/venues/presentation/providers/venue_provider.dart';
import 'package:rock_route/features/venues/presentation/providers/location_provider.dart';
import 'package:rock_route/features/venues/presentation/widgets/venue_detail_sheet.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {

  static const CameraPosition _mersinCenter = CameraPosition(
    target: LatLng(36.7783, 34.6415),
    zoom: 14.4746
  );

  @override
  Widget build(BuildContext context) {
    // Veri artık Overpass'tan geliyor ama Google Map UI'ında çizilecek!
    final venueState = ref.watch(venueProvider);
    final locationState = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("RockRoute Harita",style: TextStyle(fontWeight: FontWeight.bold),),),
      body: venueState.when(
        error: (err, stack) => Center(child: Text("Hata $err"),),
        loading: () => const Center(child: CircularProgressIndicator()),
        data: (venues) {
          final markers = venues.map((venue){
            return Marker(
              markerId: MarkerId(venue.id),
              position: LatLng(venue.latitude, venue.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
              onTap: () {
                showVenueDetailSheet(context, venue);
              },
            );
          }).toSet(); 

          CameraPosition initialCamera = _mersinCenter;

          locationState.whenData((position){
            if (position != null) {
              initialCamera = CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14.0
              );
            }
          });

          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: initialCamera,
            markers: markers,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
          );
        },
      ),
    );
  }
}