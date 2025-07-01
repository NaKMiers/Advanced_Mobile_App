import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  final Category category;
  final bool hideMenu;

  const CategoryWidget({
    Key? key,
    required this.category,
    this.hideMenu = false,
  }) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  bool deleting = false;

  void handleDelete(BuildContext context) async {
    setState(() => deleting = true);

    try {
      await deleteCategoryApi(widget.category.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted successfully')),
      );

      context.read<LoadProvider>().refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete category')),
      );
    } finally {
      setState(() => deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final settingsProvider = context.read<SettingsProvider>();
    final currency = settingsProvider.settings?.currency;
    final style = checkTranType(category.type);

    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: style['background'],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              const SizedBox(width: 12),
              Text(category.icon, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (currency != null)
                Text(
                  formatCurrency(currency, category.amount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (!widget.hideMenu && category.deletable)
                Container(
                  height: 24,
                  margin: const EdgeInsets.only(left: 8),
                  width: 24,
                  child: deleting
                      ? CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                      : PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          iconSize: 24,
                          icon: Icon(Icons.more_vert, color: Colors.white),
                          onSelected: (value) {
                            switch (value) {
                              case 'add_transaction':
                                Navigator.pushNamed(
                                  context,
                                  '/create-transaction',
                                );
                                break;
                              case 'set_budget':
                                Navigator.pushNamed(context, '/create-budget');
                                break;
                              case 'edit':
                                Navigator.pushNamed(
                                  context,
                                  '/update-category',
                                  arguments: category,
                                );
                                break;
                              case 'delete':
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: const BorderSide(width: 1.5),
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    title: Text(
                                      "Delete category",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: Text(
                                      "Are you sure you want to delete this category?",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          handleDelete(context);
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'add_transaction',
                              child: Text("Add Transaction"),
                            ),
                            if (category.type == 'expense')
                              const PopupMenuItem(
                                value: 'set_budget',
                                child: Text("Set Budget"),
                              ),
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text("Edit"),
                            ),
                            if (category.deletable)
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}
