class User {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String email;
  final String? username;
  final String? password;
  final String authType;
  final String? appleUserId;
  final String? googleUserId;

  final String? avatar;
  final String? name;
  final bool isDeleted;
  final bool initiated;

  final String plan;
  final DateTime? planExpiredAt;
  final int? exp;

  User({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    this.username,
    this.password,
    required this.authType,
    this.appleUserId,
    this.googleUserId,
    this.avatar,
    this.name,
    required this.isDeleted,
    required this.initiated,
    required this.plan,
    this.planExpiredAt,
    this.exp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt']).toLocal(),
      updatedAt: DateTime.parse(json['updatedAt']).toLocal(),
      email: json['email'] ?? '',
      username: json['username'],
      password: json['password'],
      authType: json['authType'] ?? 'local',
      appleUserId: json['appleUserId'],
      googleUserId: json['googleUserId'],
      avatar: json['avatar'],
      name: json['name'],
      isDeleted: json['isDeleted'] ?? false,
      initiated: json['initiated'] ?? false,
      plan: json['plan'] ?? 'free',
      planExpiredAt: json['planExpiredAt'] != null
          ? DateTime.tryParse(json['planExpiredAt'])?.toLocal()
          : null,
      exp: json['exp'] != null ? int.tryParse(json['exp'].toString()) : null,
    );
  }
}
