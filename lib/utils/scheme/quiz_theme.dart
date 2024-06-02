import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/utils/scheme/color_scheme.dart';

final quizTheme = ThemeData(
    textTheme: GoogleFonts.latoTextTheme(),
    scaffoldBackgroundColor: Color.fromARGB(255, 251, 241, 252),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white70),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(fontSize: 18),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue, width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue, width: 2)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.blue, width: 2)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.black, width: 1.5)),
    ));
