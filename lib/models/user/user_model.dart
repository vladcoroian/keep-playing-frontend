import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final int pk;
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final String location;

  UserModel({
    required this.pk,
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
