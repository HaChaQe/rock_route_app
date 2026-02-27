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

  // JSON'dan Modele (Otomatik Üreticiye Bağla)
  factory VenueModel.fromJson(Map<String, dynamic> json) => _$VenueModelFromJson(json);

  // Modelden JSON'a (Otomatik Üreticiye Bağla)
  Map<String, dynamic> toJson() => _$VenueModelToJson(this);
}