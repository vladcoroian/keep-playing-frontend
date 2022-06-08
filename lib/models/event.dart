class Event {
  final String _name;
  final String _location;
  final DateTime _dateTime;
  final String _details;

  Event(this._name, this._location, this._dateTime, this._details);

  String get name => _name;

  String get location => _location;

  String get details => _details;

  DateTime get dateTime => _dateTime;
}
