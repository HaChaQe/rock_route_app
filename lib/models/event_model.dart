class Event {
  final String id;
  final String title;
  final String description;
  final String date;
  final String locationName;
  final String imageUrl;
  final double latitude;
  final double longtitude;
  final int price;

  Event({required this.id, required this.title, required this.description, required this.date, required this.locationName, required this.imageUrl, required this.latitude, required this.longtitude, required this.price});
}

final List<Event> dummyEvents = [
    Event(
      id: "1",
      title: "Sabbath the Dio Years",
      description: "u know who is",
      date: "02 Şubat 2026",
      locationName: "Jolly Joker, Bursa",
      imageUrl: "assets/images/img4.webp",
      latitude: 40.2217,
      longtitude: 28.9634,
      price: 9999999
    ),
    Event(
      id: "2",
      title: "Dio Still Rocks",
      description: "-Tribute-",
      date: "02 Şubat 2026",
      locationName: "Jolly Joker, Bursa",
      imageUrl: "assets/images/img3.jpeg",
      latitude: 40.2217,
      longtitude: 28.9634,
      price: 1750
    ),
    Event(
      id: "3",
      title: "Iron Maiden",
      description: "u know who is",
      date: "02 Şubat 2026",
      locationName: "Jolly Joker, Bursa",
      imageUrl: "assets/images/img1.jpg",
      latitude: 40.2217,
      longtitude: 28.9634,
      price: 1500
    ),
    Event(
      id: "4",
      title: "Prime Dio",
      description: "God tier man on the silver mountain",
      date: "02 Şubat 2026",
      locationName: "Jolly Joker, Bursa",
      imageUrl: "assets/images/img2.png",
      latitude: 40.2217,
      longtitude: 28.9634,
      price: 9999999
    ),
];