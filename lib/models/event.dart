import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

class Event {
  final int pk;
  final String name;
  final String location;
  final String details;

  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final int price;
  final bool coach;

  Event._(
      {required this.pk,
      required this.name,
      required this.location,
      required this.details,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.price,
      required this.coach});

  Event({required EventModel eventModel})
      : this._(
            pk: eventModel.pk,
            name: eventModel.name,
            location: eventModel.location,
            details: eventModel.details,
            date: eventModel.getDate(),
            startTime: eventModel.getStartTime(),
            endTime: eventModel.getEndTime(),
            price: eventModel.price,
            coach: eventModel.coach);

  String getPriceInPounds() {
    return NumberFormat.simpleCurrency(name: "GBP").format(price);
  }

  String get24hStartTimeString() {
    return const DefaultMaterialLocalizations()
        .formatTimeOfDay(startTime, alwaysUse24HourFormat: true);
  }

  String get24hEndTimeString() {
    return const DefaultMaterialLocalizations()
        .formatTimeOfDay(endTime, alwaysUse24HourFormat: true);
  }
}

@JsonSerializable()
class EventModel {
  int pk;
  String name;
  String location;
  String details;

  String date;
  String start_time;
  String end_time;

  int price;
  bool coach;

  EventModel(
      {required this.pk,
      required this.name,
      required this.location,
      required this.details,
      required this.date,
      required this.start_time,
      required this.end_time,
      required this.price,
      required this.coach});

  DateTime getDate() {
    final splitDate = date.split('-');
    return DateTime(int.parse(splitDate[0]), int.parse(splitDate[1]),
        int.parse(splitDate[2]));
  }

  TimeOfDay getStartTime() {
    final splitStartTime = start_time.split(':');
    return TimeOfDay(
        hour: int.parse(splitStartTime[0]),
        minute: int.parse(splitStartTime[1]));
  }

  TimeOfDay getEndTime() {
    final splitEndTime = end_time.split(':');
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

  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  final int price;
  final bool coach;

  NewEvent(
      {required this.name,
      required this.location,
      required this.details,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.price,
      required this.coach});

  NewEvent.fromEvent(Event event)
      : this(
          name: event.name,
          location: event.location,
          details: event.details,
          date: event.date,
          startTime: event.startTime,
          endTime: event.endTime,
          price: event.price,
          coach: event.coach,
        );

  String toJson() {
    return jsonEncode(<String, String>{
      "name": name,
      'location': location,
      'details': details,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'start_time': const DefaultMaterialLocalizations()
          .formatTimeOfDay(startTime, alwaysUse24HourFormat: true),
      'end_time': const DefaultMaterialLocalizations()
          .formatTimeOfDay(endTime, alwaysUse24HourFormat: true),
      'price': price.toString(),
      'coach': coach ? 'True' : 'False'
    });
  }
}
