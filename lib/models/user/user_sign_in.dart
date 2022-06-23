class CoachSignIn {
  final String username;
  final String password;
  final String qualification;


  CoachSignIn({
    required this.username,
    required this.password,
    required this.qualification,
  });

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "qualification": qualification,
  };
}
