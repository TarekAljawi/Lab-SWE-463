import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/shopping_list_provider.dart';
import 'widgets/shopping_list_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (BuildContext context) => ShoppingListProvider()..getProducts(),
        child: MaterialApp(
          title: 'Shopping List',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const ShoppingListPage(),
        ));
  }
}