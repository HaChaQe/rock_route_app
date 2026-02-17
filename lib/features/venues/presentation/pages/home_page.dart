import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rock_route/features/venues/presentation/pages/map_page.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';
// import 'package:rock_route/features/venues/presentation/pages/favorites_page.dart';
// import 'package:rock_route/features/venues/presentation/widgets/venue_detail_sheet.dart';

class HomePage extends ConsumerWidget{
  const HomePage ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final venueState = ref.watch(venueProvider);

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          AppConstants.appName,
          style: TextStyle(fontWeight: FontWeight.bold, color: AppConstants.primaryColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      
      body: venueState.when(
        data: (venues) => Padding(
          padding: const EdgeInsets.only(
            left: AppConstants.defaultPadding,
            right: AppConstants.defaultPadding,
            top: AppConstants.defaultPadding,
            bottom: 3,
          ),
          child: ListView.builder(
            itemCount: venues.length,
            itemBuilder: (context, index) => VenueCard(venue: venues[index])
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryColor),
        ),
        error: (error, stackTrace) => Center(
          child: Text(
            "Tabancanın ucu kopti: $error",
            style: const TextStyle(color: AppConstants.errorColor),
          ),
        ),
      ),
    );
  }
}