import 'package:flutter/material.dart';
import '../models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({super.key, required this.groceryItem, required this.removeItem});

  final List<GroceryItem> groceryItem;
  final void Function(GroceryItem item) removeItem;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: groceryItem.length,
        itemBuilder: (ctx, index) => Dismissible(
            onDismissed: (direction) {
              removeItem(groceryItem[index]);
            },
            background: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(60, 244, 67, 54),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 15),
            ),
            key: ValueKey(groceryItem[index].id),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    groceryItem[index].name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                    ),
                  ),
                  leading: Container(
                    decoration: BoxDecoration(
                      color: groceryItem[index].category.color,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 25,
                    width: 25,
                  ),
                  trailing: Text(
                    groceryItem[index].quantity.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const Divider()
              ],
            )));
  }
}
