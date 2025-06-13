class Settings {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String user;
  final List<int> personalities;
  final String currency;
  final String language;

  final double freeTokensUsed;
  final bool firstLaunch;
  final bool referralCode;

  Settings({
    required this.id,
    required this.createdAt,
    required this.updatedAt,

    required this.user,
    required this.personalities,
    required this.currency,
    required this.language,
    required this.freeTokensUsed,
    required this.firstLaunch,
    required this.referralCode,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      user: json['user'],
      personalities: List<int>.from(json['personalities'] ?? []),
      currency: json['currency'] ?? 'USD',
      language: json['language'] ?? 'en',
      freeTokensUsed: (json['freeTokensUsed'] ?? 0).toDouble(),
      firstLaunch: json['firstLaunch'] ?? true,
      referralCode: json['referralCode'] ?? false,
    );
  }
}
