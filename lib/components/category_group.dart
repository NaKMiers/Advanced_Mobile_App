import 'package:advanced_mobile_app/components/category.dart';
import 'package:advanced_mobile_app/components/no_item_found.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';

class CategoryGroup extends StatelessWidget {
  final String type;
  final List<dynamic> categories;

  const CategoryGroup({
    super.key,
    required this.type,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final style = checkTranType(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(color: style['border'], width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(style['icon'], color: style['color']),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type[0].toUpperCase() + type.substring(1),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Sorted by name',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/create-category',
                    arguments: type,
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('New Category'),
                ),
              ],
            ),
          ),
          // Category list
          Padding(
            padding: const EdgeInsets.all(12),
            child: categories.isNotEmpty
                ? Column(
                    children: categories
                        .map((category) => CategoryWidget(category: category))
                        .toList(),
                  )
                : const NoItemsFound(text: 'No categories found!'),
          ),
        ],
      ),
    );
  }
}
