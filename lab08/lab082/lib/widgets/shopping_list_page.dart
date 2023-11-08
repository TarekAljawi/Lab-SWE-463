import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/data_models.dart';
import '../models/shopping_list_provider.dart';
import 'add_item_page.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Consumer<ShoppingListProvider>(
        builder: (context, state, child) {
          // Use a ListView.builder to display a list of items. You can customize this part to fit your UI.
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final item = state.products[index];

              return ListTile(
                title: Text(item.name),
                trailing: Checkbox(
                  value: item.isBought,
                  onChanged: (value) {
                    state.itemBoughtChanged(item);
                  },
                ),
                // Add more item details or actions as needed here.
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add item page
          final item = await Navigator.of(context).push<Product>(
            MaterialPageRoute(
              builder: (context) => const AddItemPage(),
            ),
          );
          if (item != null) {
            context.read<ShoppingListProvider>().addItem(item);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addItem(Product item) {
    context.read<ShoppingListProvider>().addItem(item);
  }

  @override
  void initState() {
    super.initState();
    context.read<ShoppingListProvider>().getProducts();
  }
}

/*
class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingListProvider>(
      builder: (context, model, child) => SimpleDialog(
        title: const Text('Preferences'),
        children: [
          SwitchListTile(
            value: model.groupByCategory,
            onChanged: (value) {
              setState(() => model.groupByCategoryChanged(value));
            },
            title: const Text('Group by Category'),
          ),
          SwitchListTile(
            value: model.moveBoughtDown,
            onChanged: (value) {
              setState(() => model.moveBoughtDownChanged(value));
            },
            title: const Text('Move Bought Items Down'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          )
        ],
      ),
    );
  }
}
*/