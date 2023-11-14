// ignore_for_file: unused_element, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grocery_list/screens/new_grocery_item_screen.dart';
import '../widgets/grocery_list_item.dart';
import '/models/grocery_item.dart';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';

import '../data/categories.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<GroceryItem> _groceryItem = [];
  bool _isLoading = true;
  String? _error;
  //
  //
  //
  void _loadData() async {
    final url = Uri.https(
      'fluttershoppinglist-643e5-default-rtdb.firebaseio.com',
      'shopingList.json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedData = [];
      for (final item in listData.entries) {
        final category = categoriesList.entries
            .firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
            )
            .value;

        loadedData.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ));
      }
      setState(() {
        _groceryItem = loadedData;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
      });
    }
  }

//
//
//
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (ctx) => const NewGroceryItems(),
    ));
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryItem.add(newItem);
    });
  }

//
//
//
  void _removeItem(GroceryItem item) async {
    final index = _groceryItem.indexOf(item);
    setState(() {
      _groceryItem.remove(item);
    });

    final url = Uri.https(
      'fluttershoppinglist-643e5-default-rtdb.firebaseio.com',
      'shopingList/${item.id}.json',
    );

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItem.insert(index, item);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Failed to remove item. try again later",
          ),
          duration: Duration(seconds: 2),
        ));
      });
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Item removed",
      ),
      duration: Duration(seconds: 2),
    ));
  }

//
//
//
//
  @override
  void initState() {
    _loadData();
    super.initState();
  }

  //
  //
  //
  @override
  Widget build(BuildContext context) {
//
////
    Widget content = Center(
        child: Text(
      "No items added yet.",
      style: TextStyle(
        fontSize: 25,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    ));
//
//
//
    if (_isLoading) {
      content = Center(
        child: SizedBox(
          height: 350,
          width: 250,
          child: LoadingIndicator(
            indicatorType: Indicator.ballSpinFadeLoader,
            colors: [Theme.of(context).colorScheme.onPrimary],
            strokeWidth: 2,
          ),
        ),
      );
    }

    //
    //
    if (_groceryItem.isNotEmpty) {
      content = GroceryListItem(
        groceryItem: _groceryItem,
        removeItem: _removeItem,
      );
    }
    //
    //
    if (_error != null) {
      content = Center(
        child: Text(
          _error!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      );
    }
    //
    //
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [IconButton(onPressed: _addItem, icon: const Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
