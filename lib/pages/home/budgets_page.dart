// budgets_page.dart
import 'package:advanced_mobile_app/components/budget_tab.dart';
import 'package:advanced_mobile_app/components/providers/budget_provider.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/models/budget_model.dart';
import 'package:advanced_mobile_app/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetsPage extends StatefulWidget {
  @override
  _BudgetsPageState createState() => _BudgetsPageState();
}

class _BudgetsPageState extends State<BudgetsPage> {
  List<List<dynamic>> groups = [];
  String? selectedTab;
  List<String> tabLabels = [];
  bool adLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _groupBudgets());
  }

  void _groupBudgets() {
    final budgets = context.read<BudgetProvider>().budgets;
    final Map<String, Map<String, dynamic>> grouped = {};

    for (var budget in budgets) {
      final key = '${budget.begin}-${budget.end}';
      grouped.putIfAbsent(
        key,
        () => {'begin': budget.begin, 'end': budget.end, 'budgets': <Budget>[]},
      );
      grouped[key]!['budgets'].add(budget);
    }

    final result = grouped.entries.map((e) => [e.key, e.value]).toList();

    setState(() {
      groups = result;
      selectedTab = selectedTab = result.isNotEmpty
          ? result[0][0] as String
          : null;
      tabLabels = result
          .map(
            (e) => formatTimeRange(
              (e[1] as Map<String, dynamic>)['begin'],
              (e[1] as Map<String, dynamic>)['end'],
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadProvider = Provider.of<LoadProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => loadProvider.refresh(),
          child: groups.isEmpty
              ? const Center(child: Text("No budgets found."))
              : Column(
                  children: [
                    SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          tabLabels.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ChoiceChip(
                              label: Text(tabLabels[index]),
                              selected: groups[index][0] == selectedTab,
                              onSelected: (_) {
                                setState(() => selectedTab = groups[index][0]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: groups
                            .where((e) => e[0] == selectedTab)
                            .map(
                              (e) => BudgetTab(
                                value: e[0],
                                begin: e[1]['begin'],
                                end: e[1]['end'],
                                budgets: e[1]['budgets'],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create-budget');
        },
        label: const Text('Create Budget'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
