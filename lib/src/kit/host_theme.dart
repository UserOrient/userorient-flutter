import 'package:flutter/material.dart';

/// The Flutter Theme the SDK wraps its screens in when the app has none.
///
/// Apps on the standalone `material_ui` package provide their own Theme,
/// which Flutter's [Theme.of] can't see. Without this, the SDK would fall
/// back to the default font and always render light.
///
/// Its own type, so it's never mistaken for the app's Theme.
class HostTheme extends Theme {
  const HostTheme({super.key, required super.data, required super.child});

  /// The app's brightness, however it provides its theme.
  static Brightness brightnessOf(BuildContext context) {
    if (_hasAppTheme(context)) return Theme.of(context).brightness;

    final HostTheme? host = context.findAncestorWidgetOfExactType<HostTheme>();
    if (host != null) return host.data.brightness;

    // The app's body text color follows its theme: light text, dark theme.
    // Skip WidgetsApp's debug error style, which is red whatever the theme.
    final TextStyle style = DefaultTextStyle.of(context).style;
    final Color? textColor = style.color;
    if (textColor != null && style.fontFamily != 'monospace') {
      return textColor.computeLuminance() > 0.5
          ? Brightness.dark
          : Brightness.light;
    }

    return MediaQuery.platformBrightnessOf(context);
  }

  /// A theme built from the brightness and font the app is actually using,
  /// or null when the app already has a Flutter Theme.
  static ThemeData? fallbackOf(BuildContext context) {
    if (_hasAppTheme(context)) return null;

    // Presented from inside the SDK: carry the same theme over.
    final HostTheme? host = context.findAncestorWidgetOfExactType<HostTheme>();
    if (host != null) return host.data;

    String? fontFamily = DefaultTextStyle.of(context).style.fontFamily;
    // WidgetsApp's debug error style. Seen when the context isn't under a
    // Scaffold or Material, so it says nothing about the app's font.
    if (fontFamily == 'monospace') fontFamily = null;

    return ThemeData(
      brightness: brightnessOf(context),
      fontFamily: fontFamily,
    );
  }

  static bool _hasAppTheme(BuildContext context) {
    return context.findAncestorWidgetOfExactType<Theme>() != null;
  }
}
