import 'package:flutter/material.dart';


class Category {
  final int id;
  final String name;
  final IconData icon;

  Category({required this.id, required this.name, required this.icon});
}



class Product {
  final int id;
  final String name;
  final Category category;
  bool isBought = false;
  final int quantity;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
  });
}

