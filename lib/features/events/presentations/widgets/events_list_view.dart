import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../providers/events_providers.dart';
import 'event_card.dart';

class EventsListView extends ConsumerWidget {
  const EventsListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsProvider);

    return eventsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppConstants.primaryColor)),
      error: (error, stack) => Center(child: Text('Konserler çekilemedi: $error', style: const TextStyle(color: Colors.red))),
      data: (events) {
        // BOŞ DURUM: Boşken de yenileme yapabilmesi için ListView içine aldık
        if (events.isEmpty) {
          return RefreshIndicator(
            color: AppConstants.secondaryColor, // 🤘 Konserler için turuncu loading
            backgroundColor: AppConstants.surfaceColor,
            onRefresh: () async {
              ref.invalidate(eventsProvider); // Veriyi baştan çeker
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), // Boşken de aşağı çekilebilmesi için
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Icon(Icons.music_off, size: 64, color: Colors.grey.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                const Text(
                  "Bu bölgede yaklaşan bir\nRock/Metal konseri bulunamadı.\n(Yenilemek için aşağı kaydır)",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppConstants.textSecondary),
                ),
              ],
            ),
          );
        }

        // DOLU DURUM: Konser listesini RefreshIndicator ile sarıyoruz
        return RefreshIndicator(
          color: AppConstants.secondaryColor,
          backgroundColor: AppConstants.surfaceColor,
          onRefresh: () async {
            ref.invalidate(eventsProvider); // 🤘 Riverpod'a "Eski veriyi unut, yenisini getir" emri
          },
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(), 
            padding: const EdgeInsets.all(16),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return EventCard(event: events[index]);
            },
          ),
        );
      },
    );
  }
}