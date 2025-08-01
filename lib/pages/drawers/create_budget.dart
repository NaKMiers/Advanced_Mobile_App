import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/components/providers/budget_provider.dart';
import 'package:advanced_mobile_app/components/providers/category_provider.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/wrapper.dart';
import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/requests/budget_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateBudgetPage extends StatefulWidget {
  final DateTime? begin;
  final DateTime? end;

  const CreateBudgetPage({super.key, this.begin, this.end});

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final formKey = GlobalKey<FormState>();
  final totalController = TextEditingController();
  DateTimeRange? dateRange;
  Category? selectedCategory;
  bool saving = false;

  @override
  void dispose() {
    totalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = context.read<CategoryProvider>().categories.firstWhere(
      (c) => c.type == 'expense' && !c.deletable,
    );

    // if widget.begin and widget.end are provided, set dateRange
    if (widget.begin != null && widget.end != null) {
      final begin = widget.begin!;
      final end = widget.end!;
      dateRange = DateTimeRange(start: begin, end: end);
    }
  }

  void showCategoryPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final categories = context
            .read<CategoryProvider>()
            .categories
            .where((c) => c.type == 'expense')
            .toList();
        return ListView(
          children: categories
              .map(
                (c) => ListTile(
                  leading: Text(c.icon),
                  title: Text(c.name),
                  onTap: () {
                    setState(() {
                      selectedCategory = c;
                    });
                    Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (!formKey.currentState!.validate()) return;

    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Category is required")));
      return;
    }
    if (dateRange == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Date range is required")));
      return;
    }

    final isPremium = context.read<AuthProvider>().isPremium;
    final budgetProvider = context.read<BudgetProvider>();

    if (!isPremium && budgetProvider.budgets.length >= 4) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Upgrade to Premium"),
          content: const Text("You've reached the budget limit of 4"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/premium");
              },
              child: const Text("Upgrade Now"),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => saving = true);

    try {
      await createBudgetApi({
        'total': double.tryParse(totalController.text.trim()),
        'categoryId': selectedCategory!.id,
        'begin': dateRange!.start.toUtc().toIso8601String(),
        'end': dateRange!.end.toUtc().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Budget created successfully!")),
      );

      context.read<LoadProvider>().refresh();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to create budget")));
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Budget",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: Wrapper(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // MARK: Total
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: totalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "...",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Amount is required";
                    }
                    final num = double.tryParse(value);
                    if (num == null || num <= 0) {
                      return "Amount must be greater than 0";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 21),

                // MARK: Category
                const Text(
                  "Category",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: showCategoryPicker,
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: selectedCategory != null
                        ? Text(
                            selectedCategory!.icon +
                                '   ' +
                                selectedCategory!.name,
                          )
                        : const Text("Select category"),
                  ),
                ),

                const SizedBox(height: 21),

                // MARK: Date Range
                const Text(
                  "Date Range",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => dateRange = picked);
                    }
                  },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerLeft,
                    child: dateRange != null
                        ? Text(
                            "${DateFormat.yMd().format(dateRange!.start)} - ${DateFormat.yMd().format(dateRange!.end)}",
                          )
                        : const Text("Select date range"),
                  ),
                ),

                const SizedBox(height: 24),

                // Save button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 21,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      onPressed: saving ? null : _handleSave,
                      child: saving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              'Save',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
