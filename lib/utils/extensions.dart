import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  Size get deviceSize => MediaQuery.sizeOf(this);
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
}
