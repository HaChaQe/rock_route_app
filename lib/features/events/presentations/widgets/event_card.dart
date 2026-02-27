import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../data/models/event_model.dart';
import 'package:url_launcher/url_launcher.dart'; // Bilet linkine gitmek için

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  // Bilet al butonuna basılınca tarayıcıyı açacak fonksiyon
  Future<void> _launchTicketUrl(BuildContext context) async {
    if (event.ticketUrl.isNotEmpty) {
      final Uri url = Uri.parse(event.ticketUrl);
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bilet linki açılamadı!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      child: Row(
        children: [
          // SOL TARAF: Konser Afişi
          SizedBox(
            width: 120,
            height: 140,
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
          
          // SAĞ TARAF: Konser Detayları
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grup / Etkinlik Adı
                  Text(
                    event.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppConstants.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Mekan Adı
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppConstants.primaryColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.venueName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppConstants.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  
                  // Tarih
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 14, color: AppConstants.primaryColor),
                      const SizedBox(width: 4),
                      Text(
                        event.date,
                        style: const TextStyle(
                          color: AppConstants.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Bilet Al Butonu
                  if (event.ticketUrl.isNotEmpty)
                    SizedBox(
                      height: 32,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () => _launchTicketUrl(context),
                        child: const Text('Bilet Bul', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}