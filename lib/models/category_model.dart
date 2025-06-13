class Category {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String name;
  final String user;
  final String icon;
  final String type;
  final double amount;
  final bool deletable;

  Category({
    required this.id,
    required this.createdAt,
    required this.updatedAt,

    required this.user,
    required this.name,
    required this.icon,
    required this.type,
    required this.amount,
    required this.deletable,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      user: json['user'],
      name: json['name'],
      icon: json['icon'] ?? '',
      type: json['type'],
      amount: (json['amount'] ?? 0).toDouble(),
      deletable: json['deletable'] ?? true,
    );
  }
}
