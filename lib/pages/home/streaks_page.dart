import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/components/wrapper.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StreaksPage extends StatefulWidget {
  const StreaksPage({super.key});

  @override
  State<StreaksPage> createState() => _StreaksPageState();
}

class _StreaksPageState extends State<StreaksPage> {
  bool loading = false;
  int weekStreak = 0;
  List<String> transactionDays = [];
  List<Map<String, dynamic>> statList = [];
  int currentStreak = 0;
  int longestStreak = 0;
  dynamic sss;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchStats();
    });
  }

  void fetchStats() async {
    // setState(() => loading = true);

    try {
      final stats = await getUserStatsApi(
        "?from=${DateTime.now().subtract(Duration(days: 7)).toIso8601String()}&to=${DateTime.now().toIso8601String()}",
      );

      if (stats == null) {
        print("No stats found for the user.");
        return;
      }

      final recentTransactions = stats['recentTransactions'] != null
          ? (stats['recentTransactions'] as List).map((json) {
              return {
                'id': json['id'],
                'createdAt': DateTime.parse(json['createdAt']),
              };
            }).toList()
          : [];

      final txDays = recentTransactions
          .map((tx) => DateFormat('yyyy-MM-dd').format(tx['createdAt']))
          .toList();

      final weekStart = DateTime.now().subtract(
        Duration(days: DateTime.now().weekday - 1),
      );
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      int streak = 0;
      for (int i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        final dayKey = DateFormat('yyyy-MM-dd').format(day);
        if (dayKey.compareTo(today) > 0) break;
        if (txDays.contains(dayKey)) {
          streak++;
        } else {
          break;
        }
      }

      setState(() {
        sss = stats;
        transactionDays = txDays;
        weekStreak = streak;
        currentStreak = stats['currentStreak'] ?? 0;
        longestStreak = stats['longestStreak'] ?? 0;
        statList = [
          {"title": "Transactions", "value": stats['transactionCount']},
          {"title": "Wallets", "value": stats['walletCount']},
          {"title": "Categories", "value": stats['categoryCount']},
          {"title": "Budgets", "value": stats['budgetCount']},
        ];
      });
    } catch (e) {
      print("Error fetching stats: $e");
    } finally {
      // setState(() => loading = false);
    }
  }

  String getStreakMessage(int streak, String name) {
    if (streak >= 7) return "You're unstoppable this week! $name 🔥🔥🔥";
    if (streak >= 5) return "You're crushing it! Keep pushing $name 💪";
    if (streak >= 3) return "You're building a great habit! $name 🙌";
    if (streak >= 1) return "Nice! One step at a time $name 🚶‍♂️";
    return "New week, new chance. Let’s get it $name! 🚀";
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Streaks',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: Wrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // streak counter
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.orange, width: 2),
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  "$weekStreak",
                  style: const TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text("Week Streak", style: theme.textTheme.headlineSmall),
              Text(
                getStreakMessage(weekStreak, shortName(user)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 21),

              // Week fire icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  final start = DateTime.now().subtract(
                    Duration(days: DateTime.now().weekday - 1),
                  );
                  final day = start.add(Duration(days: index));
                  final weekday = DateFormat.E(
                    locale.toLanguageTag(),
                  ).format(day);
                  final dayKey = DateFormat('yyyy-MM-dd').format(day);
                  final hasTx = transactionDays.contains(dayKey);
                  return Column(
                    children: [
                      Image.asset(
                        hasTx
                            ? 'assets/icons/fire.png'
                            : 'assets/icons/pale-fire.png',
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        weekday,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                }),
              ),

              const SizedBox(height: 21),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text("Current streak"),
                      Text(
                        currentStreak.toString(),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text("Longest streak"),
                      Text(
                        longestStreak.toString(),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats
              loading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "Your Stats",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: theme.colorScheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: statList
                                  .map(
                                    (stat) => SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Column(
                                        children: [
                                          Text(
                                            stat['title'],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                          Text(
                                            "${stat['value']}",
                                            style: TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  theme.colorScheme.onPrimary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),

              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
