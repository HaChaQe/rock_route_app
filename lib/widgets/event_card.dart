import 'package:flutter/material.dart';
import '../views/details/detail_view.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key});

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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetailView()),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              // Burada sadece üst köşeleri yuvarlıyoruz, altlar düz kalıyor.
              // Böylece resim kartla bütünleşiyor.
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                "assets/images/img1.jpg",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "%100 Metal Sunar: Mighty Metal",
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
                      const Text("02 Şubat 2026", style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      const Text("Bursa, Jolly Joker", style: TextStyle(color: Colors.grey)),
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