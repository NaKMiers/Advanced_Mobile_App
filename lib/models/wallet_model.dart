class Wallet {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String user;
  final String name;
  final String icon;
  final bool exclude;

  final double income;
  final double expense;
  final double saving;
  final double invest;
  final double transfer;

  Wallet({
    required this.id,
    required this.createdAt,
    required this.updatedAt,

    required this.user,
    required this.name,
    required this.icon,
    required this.exclude,

    required this.income,
    required this.expense,
    required this.saving,
    required this.invest,
    required this.transfer,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      user: json['user'],
      name: json['name'],
      icon: json['icon'] ?? '',
      exclude: json['exclude'] ?? false,

      income: (json['income'] ?? 0).toDouble(),
      expense: (json['expense'] ?? 0).toDouble(),
      saving: (json['saving'] ?? 0).toDouble(),
      invest: (json['invest'] ?? 0).toDouble(),
      transfer: (json['transfer'] ?? 0).toDouble(),
    );
  }
}
