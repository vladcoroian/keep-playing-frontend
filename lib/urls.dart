class URL {
  static const String PREFIX = "https://keep-playing.herokuapp.com/";
  static const String EVENTS = "${PREFIX}events/";

  static Uri deleteEvent(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }
  static Uri addEvent() {
    return Uri.parse("$EVENTS");
  }
  static Uri updateEvent(int pk) {
    return Uri.parse("$EVENTS$pk/");
  }
}
