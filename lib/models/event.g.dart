// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      pk: json['pk'] as int,
      name: json['name'] as String,
      location: json['location'] as String,
      details: json['details'] as String,
      date: json['date'] as String,
      start_time: json['start_time'] as String,
      end_time: json['end_time'] as String,
      price: json['price'] as int,
      coach: json['coach'] as bool,
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'pk': instance.pk,
      'name': instance.name,
      'location': instance.location,
      'details': instance.details,
      'date': instance.date,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'price': instance.price,
      'coach': instance.coach,
    };
