// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '/data/categories.dart';
import '/models/category.dart';
import '/models/grocery_item.dart';

class NewGroceryItems extends StatefulWidget {
  const NewGroceryItems({super.key});

  @override
  State<NewGroceryItems> createState() => _NewGroceryItemsState();
}

class _NewGroceryItemsState extends State<NewGroceryItems> {
  final _key = GlobalKey<FormState>();
  String _nameEntered = "";
  int _enteredQuantity = 1;
  Category _selectedCategory = categoriesList[Categories.other]!;
  bool _isSending = false;

  void _saveForm() async {
    if (_key.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _key.currentState!.save();
      final url = Uri.https('fluttershoppinglist-643e5-default-rtdb.firebaseio.com', 'shopingList.json');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'name': _nameEntered,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.title,
          }),
        );
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              "Failed to add item.Please try again later.",
            ),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
                label: "Ok",
                onPressed: () {
                  setState(() {
                    _isSending = false;
                    Navigator.pop(context);
                  });
                }),
          ));
        }
        final Map<String, dynamic> resData = json.decode(response.body);
        if (!context.mounted) {
          return;
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "New Item added",
          ),
          duration: Duration(seconds: 2),
        ));
        Navigator.of(context).pop(GroceryItem(
          id: resData['name'],
          name: _nameEntered,
          quantity: _enteredQuantity,
          category: _selectedCategory,
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Something went wrong.Please try again later.",
          ),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
              label: "Ok",
              onPressed: () {
                setState(() {
                  _isSending = false;
                  Navigator.pop(context);
                });
              }),
        ));
      }
    }
  }

  void _resetForm() {
    _key.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
            key: _key,
            child: Column(
              children: [
                _nameField(),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _quantityField(),
                    const SizedBox(width: 10),
                    //
                    _dropDownMenu()
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                _buttonWidget()
              ],
            )),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      maxLength: 50,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      decoration: InputDecoration(
        label: Text(
          'name',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.trim().length <= 1 || value.trim().length > 50) {
          return "Must be between 1 to 50 characters.";
        }
        return null;
      },
      onSaved: (v) {
        _nameEntered = v!;
      },
    );
  }

  Widget _quantityField() {
    return Expanded(
      child: TextFormField(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            label: Text(
          'Quantity',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        )),
        initialValue: _enteredQuantity.toString(),
        validator: (value) {
          if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0) {
            return "Must be a valid,positive number.";
          }
          return null;
        },
        onSaved: (v) {
          _enteredQuantity = int.parse(v!);
        },
      ),
    );
  }

  Widget _dropDownMenu() {
    return Expanded(
      child: DropdownButtonFormField(
          value: _selectedCategory,
          items: [
            for (final category in categoriesList.entries) //entries helps convert map into list
              DropdownMenuItem(
                  value: category.value,
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: category.value.color),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        category.value.title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      )
                    ],
                  )),
          ],
          onChanged: (v) {
            setState(() {
              _selectedCategory = v!;
            });
          }),
    );
  }

  Widget _buttonWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MaterialButton(
            onPressed: _isSending ? null : _saveForm,
            color: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: _isSending
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: LoadingIndicator(
                      indicatorType: Indicator.ballSpinFadeLoader,
                      colors: [Colors.green],
                      strokeWidth: 4,
                    ),
                  )
                : Text(
                    "Submit",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )),
        const SizedBox(
          width: 9,
        ),
        MaterialButton(
            onPressed: _isSending ? null : _resetForm,
            color: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "Reset",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )),
      ],
    );
  }
}
