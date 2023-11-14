import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_list/data/themes/themes.dart';

import 'screens/grocery_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery List',
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: const GroceryListScreen(),
    );
  }
}
