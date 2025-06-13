class User {
  final String id;

  final String? name;
  final String? username;
  final String? email;
  final bool isDeleted;

  final String? plan;
  final DateTime? planExpiredAt;
  final int exp;

  User({
    required this.id,
    this.name,
    this.username,
    this.email,
    this.plan,
    this.planExpiredAt,
    this.isDeleted = false,
    required this.exp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? json['sub'] ?? '',

      username: json['username'],
      email: json['email'],
      isDeleted: json['isDeleted'] ?? false,

      plan: json['plan'],
      planExpiredAt: json['planExpiredAt'] != null
          ? DateTime.parse(json['planExpiredAt'])
          : null,
      exp: json['exp'] ?? 0,
    );
  }
}
