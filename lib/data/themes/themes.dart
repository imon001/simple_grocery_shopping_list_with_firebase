import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.black87,
    centerTitle: true,
    elevation: 3,
  ),
  //colorSchemeSeed: Colors.purple,
  colorScheme: ColorScheme.light(
    background: Colors.blue.shade50,
    onBackground: Colors.blue.shade100,
    primary: Colors.blue.shade300,
    secondary: Colors.blue.shade500,
    onPrimary: Colors.black87, //for text color
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

ThemeData darkMode = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey.shade900,
    foregroundColor: Colors.white70,
    centerTitle: true,
    elevation: 3,
  ),
  brightness: Brightness.dark,
  //colorSchemeSeed: Colors.grey,
  colorScheme: ColorScheme.dark(
    background: Colors.blueGrey.shade800,
    primary: Colors.blueGrey.shade700,
    secondary: Colors.blueGrey.shade500,
    onPrimary: Colors.white70, //for text color
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);
