import 'package:flutter/material.dart';
import 'package:music_player/themes/dark_mode.dart';
import 'package:music_player/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  // light mode at first
  ThemeData _themeData = lightMode;

  // get current theme
  ThemeData get themeData => _themeData;

  // check if dark mode is active
  bool get isDarkMode => _themeData == darkMode;

  // set new theme and notify listeners
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();  // Notify listeners when the theme changes
  }

  // toggle theme between light and dark mode
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
    notifyListeners();  // Notify listeners when the theme is toggled
  }
}
