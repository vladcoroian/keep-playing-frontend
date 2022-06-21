import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keep_playing_frontend/models/user.dart';
import 'package:table_calendar/table_calendar.dart';

import 'event_model.dart';

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
          startTime: eventModel.getStartTime(),
          endTime: eventModel.getEndTime(),
          flexibleStartTime: eventModel.getFlexibleStartTime(),
          flexibleEndTime: eventModel.getFlexibleEndTime(),
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

  bool check({
    required bool allowPastEvents,
    required bool allowPendingEvents,
    required bool allowScheduledEvents,
    DateTime? onDay,
    User? withCoachUser,
  }) {
    bool result = true;
    if (!allowPastEvents) {
      result = result && !isInThePast();
    }
    if (!allowPendingEvents) {
      result = result && hasCoach();
    }
    if (!allowScheduledEvents) {
      result = result && !hasCoach();
    }
    switch (onDay) {
      case null:
        break;
      default:
        result = result && isSameDay(date, onDay!);
    }
    switch (withCoachUser) {
      case null:
        break;
      default:
        result = result && coachPK == withCoachUser!.pk;
    }
    return result;
  }
}
