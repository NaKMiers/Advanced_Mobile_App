import 'package:advanced_mobile_app/components/providers/category_provider.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/wrapper.dart';
import 'package:advanced_mobile_app/models/budget_model.dart';
import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/requests/budget_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateBudgetPage extends StatefulWidget {
  final Budget budget;

  const UpdateBudgetPage({super.key, required this.budget});

  @override
  State<UpdateBudgetPage> createState() => _UpdateBudgetPageState();
}

class _UpdateBudgetPageState extends State<UpdateBudgetPage> {
  final formKey = GlobalKey<FormState>();
  final totalController = TextEditingController();
  DateTimeRange? dateRange;
  Category? selectedCategory;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    totalController.text = widget.budget.total.toString();
    selectedCategory = widget.budget.category;

    dateRange = DateTimeRange(
      start: widget.budget.begin,
      end: widget.budget.end,
    );
  }

  @override
  void dispose() {
    totalController.dispose();
    super.dispose();
  }

  void showCategoryPicker() {
    final categories = context.read<CategoryProvider>().categories;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final expenseCates = categories
            .where((c) => c.type == 'expense')
            .toList();
        return ListView(
          children: expenseCates
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

  /// check if user has changed any field
  bool hasChanged() {
    if (selectedCategory?.id != widget.budget.category.id) return true;
    if (totalController.text != widget.budget.total.toString()) return true;
    if (dateRange?.start != widget.budget.begin) return true;
    if (dateRange?.end != widget.budget.end) return true;
    return false;
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

    // check no changes
    if (!hasChanged()) {
      Navigator.pop(context);
      return;
    }

    setState(() => saving = true);

    try {
      await updateBudgetApi(widget.budget.id, {
        'total': double.tryParse(totalController.text.trim()),
        'categoryId': selectedCategory!.id,
        'begin': dateRange!.start.toUtc().toIso8601String(),
        'end': dateRange!.end.toUtc().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Budget updated successfully!")),
      );

      context.read<LoadProvider>().refresh();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to update budget")));
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
          "Update Budget",
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
                            "${selectedCategory!.icon}   ${selectedCategory!.name}",
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
                      initialDateRange: dateRange,
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

                // MARK: Save + Cancel
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
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
                                color: theme.colorScheme.onPrimary,
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
