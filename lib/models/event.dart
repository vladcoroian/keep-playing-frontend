import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  String name;
  String location;
  String details;

  String date;
  String start_time;
  String end_time;

  double price;

  Event(
      {required this.name,
      required this.location,
      required this.details,
      required this.date,
      required this.start_time,
      required this.end_time,
      required this.price});

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
    final splitStartTime = start_time.split(':');
    return "${int.parse(splitStartTime[0])}:${int.parse(splitStartTime[1])}";
  }

  TimeOfDay getEndTime() {
    final splitEndTime = end_time.split(':');
    return TimeOfDay(
        hour: int.parse(splitEndTime[0]), minute: int.parse(splitEndTime[1]));
  }

  String getEndTimeToString() {
    final splitEndTime = end_time.split(':');
    return "${int.parse(splitEndTime[0])}:${int.parse(splitEndTime[1])}";
  }

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  Map<String, dynamic> toJson() => _$EventToJson(this);
}
