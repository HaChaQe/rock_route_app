import 'package:flutter/material.dart';
import '../../widgets/event_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RockRoute 🎸"),
        actions: [
          IconButton(
          onPressed: (){}, 
          icon: const Icon(Icons.notifications)
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          EventCard(),
          EventCard(),
          EventCard(),
          EventCard(),
          EventCard(),
          EventCard(),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}