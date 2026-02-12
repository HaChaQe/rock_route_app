import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';

class HomePage extends ConsumerWidget{
  const HomePage ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final venueState = ref.watch(VenueProvider);

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
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
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