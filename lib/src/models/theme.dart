import 'package:flutter/material.dart';

class UserOrientColors {
  final Color? backgroundColor;
  final Color? accentColor;

  const UserOrientColors({
    this.backgroundColor,
    this.accentColor,
  });
}

class UserOrientTheme {
  final UserOrientColors? light;
  final UserOrientColors? dark;

  const UserOrientTheme({
    this.light,
    this.dark,
  });
}
