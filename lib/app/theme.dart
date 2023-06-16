import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  primaryColor: const Color(0xFFFF6289),
  scaffoldBackgroundColor: const Color(0xFF181818),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xff181818),
    selectedItemColor: Color(0xFFFF6289),
    unselectedItemColor: Color(0xFF8C8C8C),
  ),
  cardColor: const Color(0xFF252628),
  tabBarTheme: const TabBarTheme(
    labelColor: Color(0xFFFF6289),
    unselectedLabelColor: Color(0xFFD5D5D5),
  ),
  textTheme: _textTheme(const Color(0xFFD5D5D5)),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff181818),
    iconTheme: IconThemeData(color: Color(0xFFD5D5D5)),
    actionsIconTheme: IconThemeData(color: Color(0xFFD5D5D5)),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFFD5D5D5),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFFD5D5D5),
  ),
  colorScheme: const ColorScheme(
    primary: Color(0xFFFF6289),
    secondary: Color(0xFFFF6289),
    background: Color(0xFF181818),
    surface: Color(0xFF252628),
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Color(0xFF606163),
    onSurface: Color(0xFFD5D5D5),
    onBackground: Color(0xFF606163),
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xff181818)),
);

final lightTheme = ThemeData.light().copyWith(
  primaryColor: const Color(0xFFFF6289),
  scaffoldBackgroundColor: const Color(0xFFFFFFFF),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFFFFFFF),
    selectedItemColor: Color(0xFFFF6289),
  ),
  cardColor: const Color(0xFFFFFFFF),
  tabBarTheme: const TabBarTheme(
    labelColor: Color(0xFFFF6289),
    unselectedLabelColor: Color(0xFF383838),
  ),
  textTheme: _textTheme(const Color(0xFF383838)),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFFFFFFF),
    iconTheme: IconThemeData(color: Color(0xFF383838)),
    actionsIconTheme: IconThemeData(color: Color(0xFF383838)),
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF383838),
    ),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF383838),
  ),
  colorScheme: const ColorScheme(
    primary: Color(0xFFFF6289),
    secondary: Color(0xFFFF6289),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFE9E9EA),
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Color(0x40383838),
    onSurface: Color(0xFF383838),
    onBackground: Color(0x40383838),
    onError: Colors.white,
    brightness: Brightness.dark,
  ),
  bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xFFFFFFFF)),
);

TextTheme _textTheme(Color color) => TextTheme(
      headline6: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      subtitle1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      subtitle2: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      bodyText1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      bodyText2: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color,
      ),
      overline: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
