// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      name: json['name'] as String,
      location: json['location'] as String,
      details: json['details'] as String,
      date: json['date'] as String,
      start_time: json['start_time'] as String,
      end_time: json['end_time'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'name': instance.name,
      'location': instance.location,
      'details': instance.details,
      'date': instance.date,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
      'price': instance.price,
    };
