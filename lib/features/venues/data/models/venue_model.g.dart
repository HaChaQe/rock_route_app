// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VenueModel _$VenueModelFromJson(Map<String, dynamic> json) => VenueModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  rating: (json['rating'] as num).toDouble(),
  category: json['category'] as String,
  isFavorite: json['isFavorite'] as bool? ?? false,
);

Map<String, dynamic> _$VenueModelToJson(VenueModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'category': instance.category,
      'isFavorite': instance.isFavorite,
    };
