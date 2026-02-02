import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:go_router/go_router.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      color: const Color(0xFF1E1E1E),

      // Bunu yazmazsan tıklama efekti (Ripple) görünmez!
      // Kartın köşelerini keskinleştirir ve efekti içeri hapseder.
      clipBehavior: Clip.antiAlias, 
      
      child: InkWell(
        // Tıklama efektinin rengini hafif beyaz yapalım ki belli olsun
        splashColor: Colors.white30,
        onTap: () {
          // Artık sayfayı direkt açmıyoruz, adrese (URL) gidiyoruz.
          // Router arka planda ID'yi alıp doğru veriyi bulacak.
          context.push('/details/${event.id}');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              // Burada sadece üst köşeleri yuvarlıyoruz, altlar düz kalıyor.
              // Böylece resim kartla bütünleşiyor.
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                event.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(height: 200, color: Colors.grey, child: const Center(child: Icon(Icons.error)));
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(event.date, style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(event.locationName, style: TextStyle(color: Colors.grey)),
                    ],
                  )
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}