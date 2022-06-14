import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String location;

  User._(
      {required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.location});

  User.fromModel({required UserModel userModel})
      : this._(
            username: userModel.username,
            email: userModel.email,
            firstName: userModel.first_name,
            lastName: userModel.last_name,
            location: userModel.location);
}

@JsonSerializable()
class UserModel {
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final String location;

  UserModel({
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

class UserLogin {
  final String username;
  final String password;

  UserLogin({required this.username, required this.password});

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
