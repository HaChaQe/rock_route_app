import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/venue_provider.dart';
import '../widgets/venue_card.dart';
import '../widgets/venue_shimmer_list.dart';


final List<String> _categories = ["Tümü", "Rock Bar", "Pub", "Canlı Müzik", "Metal"];

class HomePage extends ConsumerWidget{
  const HomePage ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final filteredState = ref.watch(filteredVenuesProvider);

    final selectedCategory = ref.watch(selectedCategoryProvider);

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
      
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.black : AppConstants.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppConstants.primaryColor,
                    backgroundColor: AppConstants.surfaceColor,
                    onSelected: (bool selected) {
                      ref.read(selectedCategoryProvider.notifier).state = category;
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: filteredState.when(
              data: (venues) {
                if (venues.isEmpty) {
                  return const Center(
                    child: Text(
                      "Bu kategoride mekan bulunamadı :/",
                      style: TextStyle(color:AppConstants.secondaryColor, fontSize: 16),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.defaultPadding,
                    right: AppConstants.defaultPadding,
                    top: AppConstants.defaultPadding,
                    bottom: 3
                  ),
                  child: ListView.builder(
                    itemCount: venues.length,
                    itemBuilder: (context, index) => VenueCard(venue: venues[index]),
                  ),
                );
              },
              loading: () => const VenueShimmerList(),
              error: (error, stackTrace) => Center(
                child: Text(
                  "Tabancanın ucu kopti: $error",
                  style: const TextStyle(color: AppConstants.errorColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}