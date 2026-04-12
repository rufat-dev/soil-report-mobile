import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ContextShortcuts on BuildContext {
  void showSnackBar(SnackBar snackBar) => ScaffoldMessenger.of(this).showSnackBar(snackBar);
}

