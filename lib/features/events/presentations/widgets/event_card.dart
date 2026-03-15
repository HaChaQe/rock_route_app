import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/event_model.dart';
import 'event_detail_sheet.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
  // DateTime nesnesini istediğimiz formata sokuyoruz
  String simpleDate = DateFormat('dd.MM.yyyy').format(event.date);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => showEventDetailSheet(context, event),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // 🤘 Her şeyi üste dayar
          children: [
            // 1. SOL TARAF: Konser Afişi
            SizedBox(
              width: 110,
              height: 110, // Yüksekliği kısalttık
              child: event.imageUrl.isNotEmpty
                  ? Image.network(
                      event.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Center(child: Icon(Icons.music_note, color: Colors.white54)),
                      ),
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Center(child: Icon(Icons.music_note, color: Colors.white54)),
                    ),
            ),
            
            // 2. SAĞ TARAF: Detaylar
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ÜST SATIR: Konser Adı ve 🤘 YANDAKİ BADGE (Tarih)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppConstants.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // TARİH BADGE (Yanda duruyor)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppConstants.secondaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppConstants.secondaryColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            simpleDate,
                            style: const TextStyle(
                              color: AppConstants.secondaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12), // Aradaki boşluk
                    
                    // ALT SATIR: Mekan Adı (İkonla birlikte)
                    Row(
                      children: [
                        const Icon(Icons.stadium_outlined, size: 14, color: AppConstants.secondaryColor),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.venueName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppConstants.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}