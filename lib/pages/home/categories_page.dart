import 'package:advanced_mobile_app/components/category_group.dart';
import 'package:advanced_mobile_app/components/header.dart';
import 'package:advanced_mobile_app/components/no_item_found.dart';
import 'package:advanced_mobile_app/components/providers/category_provider.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/wrapper.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<String> _tabs = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categories = context.read<CategoryProvider>().categories;
      _generateTabs(categories);
    });
  }

  void _generateTabs(List categories) {
    final desiredOrder = ['expense', 'income', 'saving', 'invest'];
    final types = <String>{};
    for (var category in categories) {
      types.add(category.type);
    }
    _tabs = desiredOrder.where((t) => types.contains(t)).toList();
    _tabController = TabController(length: _tabs.length, vsync: this);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final loadProvider = Provider.of<LoadProvider>(context);
    final categories = categoryProvider.categories;

    final grouped = <String, List>{};
    for (var category in categories) {
      grouped.putIfAbsent(category.type, () => []).add(category);
    }

    if (_tabs.isEmpty) {
      _generateTabs(categories);
    }

    return Scaffold(
      appBar: Header(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => loadProvider.refresh(),
          child: Wrapper(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pushNamed(context, "/account"),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Categories",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                if (_tabs.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: Column(
                      children: [
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: Theme.of(context).colorScheme.primary,
                          unselectedLabelColor: Colors.grey,
                          tabs: _tabs
                              .map((type) => Tab(text: capitalize(type)))
                              .toList(),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: _tabs.map((type) {
                              final items = grouped[type] ?? [];
                              return ListView(
                                padding: const EdgeInsets.all(16),
                                children: [
                                  if (items.isEmpty)
                                    const NoItemsFound(
                                      text: 'No categories found!',
                                    )
                                  else
                                    CategoryGroup(
                                      type: type,
                                      categories: items,
                                    ),
                                  const SizedBox(height: 200),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      // Floating Add Button
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () => Navigator.pushNamed(context, '/create-category'),
        icon: const Icon(Icons.add),
        label: const Text("Create Category"),
      ),
    );
  }
}
