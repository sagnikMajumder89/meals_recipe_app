import 'package:flutter/material.dart';
import 'package:meals_recipe/providers/filter_provider.dart';
import 'package:meals_recipe/screen/categories.dart';
import 'package:meals_recipe/screen/filters.dart';
import 'package:meals_recipe/screen/meals.dart';
import 'package:meals_recipe/widget/drawer_main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_recipe/providers/favourtie_meals_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _selectScreen(String identifier) async {
    Navigator.pop(context);
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
          MaterialPageRoute(builder: (_) => const FiltersScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);
    Widget activePage = CategoriesScreen(
      availableMeal: availableMeals,
    );
    var activePageTitle = 'Categories';
    final favoriteMeals = ref.watch(favouriteMealsProvider);
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      drawer: MainDrawer(
        onSelectScreen: _selectScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          _selectPage(index);
        },
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
