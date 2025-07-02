import 'package:advanced_mobile_app/components/providers/category_provider.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:advanced_mobile_app/requests/transaction_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateTransactionPage extends StatefulWidget {
  final Transaction transaction;

  const UpdateTransactionPage({super.key, required this.transaction});

  @override
  State<UpdateTransactionPage> createState() => _UpdateTransactionPageState();
}

class _UpdateTransactionPageState extends State<UpdateTransactionPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedType = "expense";
  Category? selectedCategory;
  Wallet? selectedWallet;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.transaction.name;
    amountController.text = widget.transaction.amount.toString();
    selectedDate = widget.transaction.date;
    selectedType = widget.transaction.type;
    selectedCategory = widget.transaction.category;
    selectedWallet = widget.transaction.wallet;
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void showCategoryPicker() {
    final categories = context.read<CategoryProvider>().categories;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final filtered = categories
            .where((c) => c.type == selectedType)
            .toList();
        return ListView(
          children: filtered
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

  void showWalletPicker() {
    final wallets = context.read<WalletProvider>().wallets;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: wallets
              .map(
                (w) => ListTile(
                  leading: Text(w.icon ?? "💰"),
                  title: Text(w.name),
                  onTap: () {
                    setState(() {
                      selectedWallet = w;
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

    if (selectedWallet == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Wallet is required")));
      return;
    }
    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Category is required")));
      return;
    }

    // Check change
    final tx = widget.transaction;
    if (tx.name == nameController.text.trim() &&
        tx.amount == double.tryParse(amountController.text.trim()) &&
        tx.wallet.id == selectedWallet!.id &&
        tx.category.id == selectedCategory!.id &&
        tx.type == selectedType &&
        DateFormat.yMd().format(tx.date) ==
            DateFormat.yMd().format(selectedDate)) {
      Navigator.pop(context); // no changes
      return;
    }

    setState(() => saving = true);

    try {
      await updateTransactionApi(tx.id, {
        "name": nameController.text.trim(),
        "amount": double.tryParse(amountController.text.trim()),
        "date": selectedDate.toUtc().toIso8601String(),
        "walletId": selectedWallet!.id,
        "categoryId": selectedCategory!.id,
        "type": selectedType,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction updated successfully!")),
      );

      context.read<LoadProvider>().refresh();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update transaction")),
      );
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String currency =
        context.read<SettingsProvider>().settings?.currency ?? 'USD';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Transaction",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              const Text(
                "Name",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Amount
              const Text(
                "Amount",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "...",
                  prefixText: "$currency ",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  final num = double.tryParse(value ?? "");
                  if (num == null || num <= 0) {
                    return "Amount must be greater than 0";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Type
              const Text("Type", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ["expense", "income", "saving", "invest"]
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(
                          type[0].toUpperCase() + type.substring(1),
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val == null) return;
                  setState(() {
                    selectedType = val;
                    selectedCategory = null;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
              const SizedBox(height: 16),

              // Category
              const Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: showCategoryPicker,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: selectedCategory != null
                      ? Text(
                          "${selectedCategory!.icon} ${selectedCategory!.name}",
                        )
                      : const Text("Select category"),
                ),
              ),
              const SizedBox(height: 16),

              // Wallet
              const Text(
                "Wallet",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: showWalletPicker,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: selectedWallet != null
                      ? Text("${selectedWallet!.icon} ${selectedWallet!.name}")
                      : const Text("Select wallet"),
                ),
              ),
              const SizedBox(height: 16),

              // Date
              const Text("Date", style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => selectedDate = picked);
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(DateFormat.yMMMd().format(selectedDate)),
                ),
              ),
              const SizedBox(height: 24),

              // Save + Cancel
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: saving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    child: saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            "Save",
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
    );
  }
}
