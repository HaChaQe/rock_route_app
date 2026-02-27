// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: json['id'] as String,
  name: json['name'] as String,
  ticketUrl: json['ticketUrl'] as String,
  imageUrl: json['imageUrl'] as String,
  date: json['date'] as String,
  venueName: json['venueName'] as String,
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ticketUrl': instance.ticketUrl,
      'imageUrl': instance.imageUrl,
      'date': instance.date,
      'venueName': instance.venueName,
    };
