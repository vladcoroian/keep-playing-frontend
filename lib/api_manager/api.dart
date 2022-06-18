import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:keep_playing_frontend/api_manager/api_events.dart';
import 'package:keep_playing_frontend/api_manager/api_users.dart';

const int HTTP_201_CREATED = 201;
const int HTTP_202_ACCEPTED = 202;

class API {
  static const String PREFIX = "https://keep-playing-staging.herokuapp.com/";

  static final Client client = http.Client();

  static ApiEvents events = ApiEvents(client: client);
  static ApiUsers users = ApiUsers(client: client);
}
