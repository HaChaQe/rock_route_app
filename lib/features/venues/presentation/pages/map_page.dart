import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:rock_route/core/constants/app_constants.dart';
// import 'package:rock_route/features/venues/data/models/venue_model.dart';
import 'package:rock_route/features/venues/presentation/providers/venue_provider.dart';
// import 'package:url_launcher/url_launcher.dart';
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

    final venueState = ref.watch(venueProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("RockRoute Harita"),),
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
          }).toSet(); // List to Set
          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _mersinCenter,
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
