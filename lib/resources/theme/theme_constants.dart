import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: Colors.blue[400]!,
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 20, 65, 57),
);

ThemeData lightTheme = ThemeData().copyWith(
  useMaterial3: true,
  colorScheme: kColorScheme,
);

ThemeData darkTheme = ThemeData.dark().copyWith(
  useMaterial3: true,
  colorScheme: kDarkColorScheme,
);
