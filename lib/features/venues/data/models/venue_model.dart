import 'package:json_annotation/json_annotation.dart';

part 'venue_model.g.dart';

@JsonSerializable()
class VenueModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final double rating;
  final String category;

  @JsonKey(defaultValue: false)
  final bool isFavorite;

  VenueModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.category,
    this.isFavorite = false,
  });

  factory VenueModel.fromJson(Map<String, dynamic> json) => _$VenueModelFromJson(json);

  Map<String, dynamic> toJson() => _$VenueModelToJson(this);

  // Modelden JSON'a (Hafızaya yazarken)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'description': description,
    };
  }

  // JSON'dan Modele (Hafızadan okurken)
  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      rating: json['rating'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageUrl: json['imageUrl'],
      description: json['description'],
    );
  }
}