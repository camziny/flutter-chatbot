class UserSession {
  final String id;
  final String email;
  final DateTime expires;

  UserSession({
    required this.id,
    required this.email,
    required this.expires,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['user']['id'],
      email: json['user']['email'],
      expires: DateTime.parse(json['expires']),
    );
  }
}