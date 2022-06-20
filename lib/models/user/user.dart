import 'user_model.dart';

class User {
  final int pk;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String location;

  User._({
    required this.pk,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.location,
  });

  User.fromModel({required UserModel userModel})
      : this._(
    pk: userModel.pk,
    username: userModel.username,
    email: userModel.email,
    firstName: userModel.first_name,
    lastName: userModel.last_name,
    location: userModel.location,
  );
}