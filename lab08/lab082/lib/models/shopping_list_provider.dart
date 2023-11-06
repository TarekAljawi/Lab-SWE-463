import 'package:flutter/material.dart';

import 'data_models.dart';
enum CategoryName { groceries, frozenAndCooledFoods, cleaning, meatAndFish }
Map<CategoryName, Category> categories = {
  CategoryName.groceries: Category(
    id: 1,
    name: 'Groceries',
    icon: Icons.emoji_food_beverage,
  ),
  CategoryName.frozenAndCooledFoods: Category(
    id: 2,
    name: 'Frozen and Cooled Foods',
    icon: Icons.ac_unit,
  ),
  CategoryName.cleaning: Category(
    id: 3,
    name: 'Cleaning',
    icon: Icons.cleaning_services,
  ),
  CategoryName.meatAndFish: Category(
    id: 4,
    name: 'Meats and Fish',
    icon: Icons.set_meal,
  )
};
class ShoppingListProvider extends ChangeNotifier {

  List<Product> products = [
    Product(
      id: 1,
      name: 'Tea Bags',
      category: categories[CategoryName.groceries]!,
      quantity: 1,
    ),
    Product(
      id: 2,
      name: 'Orange Juice',
      category: categories[CategoryName.frozenAndCooledFoods]!,
      quantity: 2,
    ),
    Product(
      id: 3,
      name: 'Detergent',
      category: categories[CategoryName.cleaning]!,
      quantity: 1,
    ),
    Product(
      id: 4,
      name: 'Milk',
      category: categories[CategoryName.frozenAndCooledFoods]!,
      quantity: 5,
    ),
  ];
  bool groupByCategory = false;
  bool moveBoughtDown = false;
  void addItem(Product item) {
    products.add(item);
    _doSorting();
    notifyListeners();
  }
  void removeItem(Product item) {
    products.remove(item);
    notifyListeners();
  }
  void groupByCategoryChanged(bool value) {
    groupByCategory = value;
    _doSorting();
    notifyListeners();
  }
  void itemBoughtChanged(Product item) {
    item.isBought = !item.isBought;
    _doSorting();
    notifyListeners();
  }
  void _doSorting() {
    if (groupByCategory && moveBoughtDown) {
      products.sort((a, b) => a.category.name.compareTo(b.category.name));
      products.sort((a, b) => a.isBought?1:-1);
    }
    else if (groupByCategory && !moveBoughtDown) {
      products.sort((a, b) => a.id.compareTo(b.id));
      products.sort((a, b) => a.category.name.compareTo(b.category.name));
    }
    else if (!groupByCategory && moveBoughtDown) {
      products.sort((a, b) => a.id.compareTo(b.id));
      products.sort((a, b) => a.isBought?1:-1);
    }
    else {
      products.sort((a, b) => a.id.compareTo(b.id));
    }
  }
  void moveBoughtDownChanged(bool value) {
    moveBoughtDown = value;
    _doSorting();
    notifyListeners();
  }
}