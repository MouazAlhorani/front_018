import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeM {
  static ThemeMode thememode = ThemeMode.light;
  static ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: const CardTheme(color: Colors.white),
    elevatedButtonTheme: const ElevatedButtonThemeData(
        style: ButtonStyle(
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)))),
    )),
    textTheme: TextTheme(
      labelLarge: GoogleFonts.elMessiri(fontSize: 25, color: Colors.black),
      labelSmall: GoogleFonts.elMessiri(
          fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      bodyMedium: GoogleFonts.elMessiri(fontSize: 17, color: Colors.black),
      bodySmall: GoogleFonts.elMessiri(fontSize: 16, color: Colors.black),
    ),
  );
}
