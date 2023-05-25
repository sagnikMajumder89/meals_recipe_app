import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_recipe/providers/meals_provider.dart';

enum Filter {
  lactoseFree,
  glutenFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.lactoseFree: false,
          Filter.glutenFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false
        });
  void setFilters(Map<Filter, bool> currentFilters) {
    state = currentFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
        (ref) => FiltersNotifier());

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final selectedFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) return false;
    if (selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree)
      return false;
    if (selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) return false;
    if (selectedFilters[Filter.vegan]! && !meal.isVegan) return false;
    return true;
  }).toList();
});
