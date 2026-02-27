import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel{
  final String id;
  final String name;
  final String ticketUrl;
  final String imageUrl;
  final String date;
  final String venueName;

  EventModel({required this.id, required this.name, required this.ticketUrl, required this.imageUrl, required this.date, required this.venueName});

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}