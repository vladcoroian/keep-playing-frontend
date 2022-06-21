import 'dart:convert';

import 'package:keep_playing_frontend/api_manager/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user.dart';

class StoredData {
  static const String _TOKEN = 'USER_TOKEN';
  static const String _USER = 'USER';

  static late User _currentUser;

  static Future<void> setLoginToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_TOKEN, token);
  }

  static Future<String> getLoginToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_TOKEN)!;
  }

  static Future<void> setCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel userModel = await API.users.getCurrentUserModel();
    prefs.setString(_USER, jsonEncode(userModel.toJson()));
    _currentUser = User.fromModel(userModel: userModel);
  }

  static User getCurrentUser() {
    return _currentUser;
  }

  static Future<User> getCurrentUserFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return User.fromModel(
      userModel: UserModel.fromJson(jsonDecode(prefs.getString(_USER)!)),
    );
  }
}
