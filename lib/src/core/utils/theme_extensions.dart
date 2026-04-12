import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

}

extension ImageSource on String {
  String themeImage(BuildContext context) {
    if (context.isDarkMode) {
      return "assets/images/dark/$this";
    } else {
      return "assets/images/light/$this";
    }
  }
}
