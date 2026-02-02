import 'package:flutter/material.dart';
import '../../models/event_model.dart';
import 'package:go_router/go_router.dart';

class DetailView extends StatelessWidget {

  final Event event;
  const DetailView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
      ),

      body: Stack(
        children: [
          //arkaplan resmi
          Positioned.fill(
            child: Image.asset(event.imageUrl,
            fit: BoxFit.cover,
            )
          ),

          //karartma perde
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black54,
                    Colors.black87,
                  ],
                ),
              ),
            ),
          ),

          //içerik
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Başlık
                Text(
                  event.title,
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                //boşluk
                const SizedBox(height: 10),

                //tarih saat
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: Color(0xFFD32F2F)),
                    SizedBox(width: 8),
                    Text(event.date, style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(width: 25),
                    Icon(Icons.location_on, color: Color(0xFFD32F2F)),
                    SizedBox(width: 8),
                    Text(event.locationName, style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ],
                ),

                //boşluk
                const SizedBox(height: 20),

                //açıklama
                Text(
                  event.description,
                  style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
                ),

                //boşluk
                const SizedBox(height: 30),

                //bilet al
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD32F2F),
                      foregroundColor: Colors.white,
                    ),
                    child: Text("BİLET AL - ${event.price} ₺", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}