import 'package:flutter/material.dart';
import 'package:keep_playing_frontend/models/event.dart';

import 'event_cards/past_event_card.dart';
import 'event_cards/pending_event_card.dart';
import 'event_cards/scheduled_event_card.dart';

class Organiser {
  static Widget getCardForEvent({required Event event}) {
    if (event.isInThePast()) {
      return PastEventCard(event: event);
    }
    if (event.hasCoach()) {
      return ScheduledEventCard(event: event);
    }
    return PendingEventCard(event: event);
  }
}
