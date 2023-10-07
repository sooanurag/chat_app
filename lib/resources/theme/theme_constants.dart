import 'package:chat_app/resources/app_colors.dart';
import 'package:flutter/material.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: AppColors.defaultGreenYellow[0],

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
  // scaffoldBackgroundColor: Colors.white,
);
