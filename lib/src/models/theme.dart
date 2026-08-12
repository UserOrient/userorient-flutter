import 'package:flutter/material.dart';

/// Custom color overrides for a single brightness mode.
class UserOrientColors {
  @Deprecated(
    'Background colors are no longer configurable — the board owns its own '
    'surface so dividers, skeletons and fades can never fall out of contrast. '
    'Will be removed in 4.0.0.',
  )
  final Color? backgroundColor;
  final Color? accentColor;

  const UserOrientColors({
    // ignore: deprecated_member_use_from_same_package
    this.backgroundColor,
    this.accentColor,
  });
}

/// Theme configuration holding light and dark color overrides.
@Deprecated(
  'Use UserOrient.configure(accentColor: ...) instead. '
  'Will be removed in 4.0.0.',
)
class UserOrientTheme {
  final UserOrientColors? light;
  final UserOrientColors? dark;

  const UserOrientTheme({
    this.light,
    this.dark,
  });
}
