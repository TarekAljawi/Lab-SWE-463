import 'package:flutter/material.dart';

import 'data_models.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ShoppingListProvider extends ChangeNotifier {
  final String categoriesUrl;
  final String productsUrl;
  final String loginUrl;
  final String registerUrl;
  http.Client? client;
  String? _token;
  int? _userId;
  Future<void> _getToken() async {
    if (_token != null) {
      return;
    } else {
      _error = null;
      try {
        final response = await client!.post(Uri.parse(loginUrl),
            body: json.encode(
                {'email': 'swe_463@example.com', 'password': 'swe_463'}),
            headers: {
              'Content-Type': 'application/json',
            });
        if (response.statusCode == 200) {
          var body = json.decode(response.body);
          _token = body['accessToken'];
          _userId = body['user']['id'];
        } else {
          _error = 'Failed to login with status code ${response.statusCode}';
        }
      } catch (e) {
        _error = e.toString();
      }
    }
  }

  ShoppingListProvider({
    this.categoriesUrl = 'http://{your IP}:3000/categories',
    this.productsUrl = 'http://{your IP}:3000/products',
    this.loginUrl = 'http://{your IP}:3000/login',
    this.registerUrl = 'http://{your IP}:3000/register',
    this.client,
  }) {
    client ??= http.Client();
  }
  List<Category> _categories = [];
  List<Product> _products = [];
  List<Category> get categories => _categories;
  List<Product> get products => _products;
  Future<void> getCategories() async {
    final response = await client!.get(Uri.parse(categoriesUrl));
    if (response.statusCode == 200) {
      final categoriesJson = (json.decode(response.body) as List);
      _categories = categoriesJson.map((e) => Category.fromJson(e)).toList();
      return notifyListeners();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  bool _isBusy = false;
  bool get isBusy => _isBusy;
  String? _error;
  String? get error => _error;

  Future<void> getProducts() async {
    _isBusy = true;
    _error = null;
    notifyListeners();
    try {
      await _getToken();
      final response = await client!.get(
        Uri.parse('$productsUrl?userId=$_userId'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final productsJson = (json.decode(response.body) as List);
        _products = productsJson.map((e) => Product.fromJson(e)).toList();
      } else {
        _error = 'Failed to load products';
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors, token retrieval errors) here.
      _error = 'An error occurred: $e';
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> addItem(Product item) async {
    _error = null;
    _isBusy = true;
    notifyListeners();

    try {
      await _getToken();

      final response = await client!.post(
        Uri.parse(productsUrl),
        body: json.encode({'userId': _userId, ...item.toJson()}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 201) {
        // Successful product addition; you can add specific handling here.
        // For example, you might want to update your local state.
      } else if (response.statusCode >= 400) {
        // Handle client or server errors
        _error =
            'Failed to add the product. Status code: ${response.statusCode}';
      } else {
        // Handle unexpected cases
        _error = 'An unexpected error occurred while adding the product.';
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors, token retrieval errors) here.
      _error = 'An error occurred: $e';
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  void itemBoughtChanged(Product item) async {
    _error = null;
    _isBusy = true;
    notifyListeners();
    try {
      item.isBought = !item.isBought;
      final response = await client!.patch(
        Uri.parse('$productsUrl/${item.id}'),
        body: jsonEncode(item.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        _doSorting();
      } else {
        _error = 'Failed to update item! Error: ${response.statusCode}';
      }
    } catch (e) {
      _error = e.toString();
    }
    _isBusy = false;
    notifyListeners();
  }

  void _doSorting() {
    // Implement your sorting logic here.
    _products.sort((a, b) => a.name.compareTo(b.name));
  }
}

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
