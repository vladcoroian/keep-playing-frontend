class User {
  String username;
  String email;
  String firstName;
  String lastName;
  String password;

  User(
      {required this.username,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.password});
}

class UserLogin {
  String username;
  String password;

  UserLogin({required this.username, required this.password});

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}

class Token {
  String token;

  Token({required this.token});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(token: json['token']);
  }
}
