import 'dart:io';

class CoachSignIn {
  final String username;
  final String password;
  final File? qualificationFile;

  CoachSignIn({
    required this.username,
    required this.password,
    required this.qualificationFile,
  });
}
