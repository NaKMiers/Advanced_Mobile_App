import 'package:advanced_mobile_app/components/providers/category_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/requests/budget_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateBudgetPage extends StatefulWidget {
  const CreateBudgetPage({super.key});

  @override
  State<CreateBudgetPage> createState() => _CreateBudgetPageState();
}

class _CreateBudgetPageState extends State<CreateBudgetPage> {
  final TextEditingController _amountController = TextEditingController();
  String? selectedCategory;
  DateTimeRange? selectedRange;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 30)),
      end: DateTime.now(),
    );
  }

  void handleSave() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null ||
        amount <= 0 ||
        selectedCategory == null ||
        selectedRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields correctly.")),
      );
      return;
    }

    setState(() => isSaving = true);

    final data = {
      "amount": amount,
      "category": selectedCategory,
      "begin": selectedRange!.start.toIso8601String(),
      "end": selectedRange!.end.toIso8601String(),
    };

    print('data: $data');

    // final res = await createBudgetApi(data);
  }

  void pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: selectedRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        context.watch<SettingsProvider>().settings?.currency ?? 'USD';
    final categories = context
        .watch<CategoryProvider>()
        .categories
        .where((cate) => cate.type == 'expense')
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Budget")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Total Amount"),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: NumberFormat.simpleCurrency(
                  name: currency,
                ).currencySymbol,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            const Text("Category"),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              hint: const Text("Select category"),
              items: categories.map((cat) {
                return DropdownMenuItem(
                  value: cat.id,
                  child: Text("${cat.icon} ${cat.name}"),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedCategory = value),
            ),
            const SizedBox(height: 16),

            const Text("Date Range"),
            InkWell(
              onTap: pickDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedRange != null
                          ? "${DateFormat.yMMMd().format(selectedRange!.start)} - ${DateFormat.yMMMd().format(selectedRange!.end)}"
                          : "Select date range",
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const Spacer(),

            ElevatedButton.icon(
              onPressed: isSaving ? null : handleSave,
              icon: isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: const Text("Save Budget"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
