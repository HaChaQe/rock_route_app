import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/events_providers.dart';
import 'event_card.dart';

class EventsListView extends ConsumerWidget {
  const EventsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ticketmaster servisini dinliyoruz
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      error: (error, stack) => Center(child: Text('Konserler çekilemedi: $error', style: const TextStyle(color: Colors.red))),
      data: (events) {
        if (events.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.music_off, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                const Text(
                  "Bu bölgede yaklaşan bir\nRock/Metal konseri bulunamadı.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppConstants.textSecondary),
                ),
              ],
            ),
          );
        }

        // Konserleri listeliyoruz
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return EventCard(event: events[index]);
          },
        );
      },
    );
  }
}