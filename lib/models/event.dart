import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

class Event {
  final int pk;

  final String name;
  final String location;
  final String details;
  final String sport;
  final String role;

  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeOfDay flexibleStartTime;
  final TimeOfDay flexibleEndTime;

  final int price;
  final bool coach;

  final int? coachPK;

  final List<int> offers;

  Event._({
    required this.pk,
    required this.name,
    required this.location,
    required this.details,
    required this.sport,
    required this.role,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.flexibleStartTime,
    required this.flexibleEndTime,
    required this.price,
    required this.coach,
    this.coachPK,
    required this.offers,
  });

  Event({required EventModel eventModel})
      : this._(
          pk: eventModel.pk,
          name: eventModel.name,
          location: eventModel.location,
          details: eventModel.details,
          sport: eventModel.sport,
          role: eventModel.role,
          date: eventModel.getDate(),
          startTime: eventModel.getTimeOfDayFromString(eventModel.start_time),
          endTime: eventModel.getTimeOfDayFromString(eventModel.end_time),
          flexibleStartTime:
              eventModel.getTimeOfDayFromString(eventModel.flexible_start_time),
          flexibleEndTime:
              eventModel.getTimeOfDayFromString(eventModel.flexible_start_time),
          price: eventModel.price,
          coach: eventModel.coach,
          coachPK: eventModel.coach_user,
          offers: eventModel.offers,
        );

  String getPriceInPounds() {
    return NumberFormat.simpleCurrency(name: "GBP").format(price);
  }

  DateTime getStartTimestamp() {
    return DateTime(
      date.year,
      date.month,
      date.day,
      startTime.hour,
      startTime.minute,
    );
  }

  DateTime getEndTimestamp() {
    return DateTime(
      date.year,
      date.month,
      date.day,
      endTime.hour,
      endTime.minute,
    );
  }

  bool isInThePast() {
    return getStartTimestamp().isBefore(DateTime.now());
  }

  bool hasCoach() {
    return coach;
  }
}

@JsonSerializable()
class EventModel {
  final int pk;
  final String name;
  final String location;
  final String details;
  final String sport;
  final String role;

  final String date;
  final String start_time;
  final String end_time;
  final String flexible_start_time;
  final String flexible_end_time;

  final int price;
  final bool coach;

  final int? coach_user;

  final List<int> offers;

  EventModel({
    required this.pk,
    required this.name,
    required this.location,
    required this.details,
    required this.sport,
    required this.role,
    required this.date,
    required this.start_time,
    required this.end_time,
    required this.flexible_start_time,
    required this.flexible_end_time,
    required this.price,
    required this.coach,
    this.coach_user,
    required this.offers,
  });

  DateTime getDate() {
    final splitDate = date.split('-');
    return DateTime(int.parse(splitDate[0]), int.parse(splitDate[1]),
        int.parse(splitDate[2]));
  }

  TimeOfDay getTimeOfDayFromString(String time) {
    final splitEndTime = time.split(':');
    return TimeOfDay(
        hour: int.parse(splitEndTime[0]), minute: int.parse(splitEndTime[1]));
  }

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);
}

class NewEvent {
  final String name;
  final String location;
  final String details;
  final String sport;
  final String role;

  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final TimeOfDay flexibleStartTime;
  final TimeOfDay flexibleEndTime;

  final int price;
  final bool coach;

  NewEvent({
    required this.name,
    required this.location,
    required this.details,
    required this.sport,
    required this.role,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.flexibleStartTime,
    required this.flexibleEndTime,
    required this.price,
    required this.coach,
  });

  NewEvent.fromEvent(Event event)
      : this(
          name: event.name,
          location: event.location,
          details: event.details,
          sport: event.sport,
          role: event.role,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          flexibleStartTime: event.flexibleStartTime,
          flexibleEndTime: event.flexibleEndTime,
          price: event.price,
          coach: event.coach,
        );

  Map<String, dynamic> toJson() => <String, dynamic>{
        "name": name,
        'location': location,
        'details': details,
        'sport': sport,
        'role': role,
        'date': DateFormat('yyyy-MM-dd').format(date),
        'start_time': const DefaultMaterialLocalizations()
            .formatTimeOfDay(startTime, alwaysUse24HourFormat: true),
        'end_time': const DefaultMaterialLocalizations()
            .formatTimeOfDay(endTime, alwaysUse24HourFormat: true),
        'flexible_start_time': const DefaultMaterialLocalizations()
            .formatTimeOfDay(flexibleStartTime, alwaysUse24HourFormat: true),
        'flexible_end_time': const DefaultMaterialLocalizations()
            .formatTimeOfDay(flexibleEndTime, alwaysUse24HourFormat: true),
        'price': price.toString(),
        'coach': coach ? 'True' : 'False'
      };
}
