import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final IconData icon;
  Category({required this.id, required this.name, required this.icon});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        icon: IconData(
          json['icon'],
          fontFamily: 'MaterialIcons',
        ));
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'icon': icon.codePoint};
  }
}

class Product {
  final int id;
  final String name;
  final Category category;
  bool isBought;
  final int quantity;
  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    this.isBought = false,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      category: Category.fromJson(json['category']),
      quantity: json['quantity'],
      isBought: json['isBought'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.toJson(),
      'quantity': quantity,
      'isBought': isBought
    };
  }
}
