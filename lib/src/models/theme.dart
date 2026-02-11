import 'package:flutter/material.dart';

/// Custom color overrides for a single brightness mode.
class UserOrientColors {
  final Color? backgroundColor;
  final Color? accentColor;

  const UserOrientColors({
    this.backgroundColor,
    this.accentColor,
  });
}

/// Theme configuration holding light and dark color overrides.
class UserOrientTheme {
  final UserOrientColors? light;
  final UserOrientColors? dark;

  const UserOrientTheme({
    this.light,
    this.dark,
  });
}
