import 'package:flutter/material.dart';
import '../../widgets/event_card.dart';
import '../../models/event_model.dart';

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyEvents.length,
        itemBuilder: (context, index){
          final currentEvent = dummyEvents[index]; //0dan başla verileri al
          return EventCard(event: currentEvent);
        },
      ),
    );
  }
}