import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  int pk;
  String name;
  String location;
  String details;

  String date;
  String start_time;
  String end_time;

  int price;
  bool coach;

  Event(
      {required this.pk,
      required this.name,
      required this.location,
      required this.details,
      required this.date,
      required this.start_time,
      required this.end_time,
      required this.price,
      required this.coach});

  String getPriceInPounds() {
    return NumberFormat.simpleCurrency(name: "GBP").format(price);
  }

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

  String getStartTimeToString() {
    return const DefaultMaterialLocalizations()
        .formatTimeOfDay(getStartTime(), alwaysUse24HourFormat: true);
  }

  TimeOfDay getEndTime() {
    final splitEndTime = end_time.split(':');
    return TimeOfDay(
        hour: int.parse(splitEndTime[0]), minute: int.parse(splitEndTime[1]));
  }

  String getEndTimeToString() {
    return const DefaultMaterialLocalizations()
        .formatTimeOfDay(getEndTime(), alwaysUse24HourFormat: true);
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
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
