import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/models/theme.dart';

extension BuildContextX on BuildContext {
  /// True when the app is in dark mode.
  ///
  /// Apps on the standalone `material_ui` package provide their own Theme,
  /// which Flutter's [Theme.of] can't see. Without a Flutter Theme above us,
  /// read it from the app's text color, then the system setting.
  bool get isDark => hostBrightness == Brightness.dark;

  bool get _hasAppTheme => findAncestorWidgetOfExactType<Theme>() != null;

  Brightness get hostBrightness {
    if (_hasAppTheme) return Theme.of(this).brightness;
    final HostTheme? host = findAncestorWidgetOfExactType<HostTheme>();
    if (host != null) return host.data.brightness;
    // The app's body text color follows its theme: light text, dark theme.
    // Skip WidgetsApp's debug error style, which is red whatever the theme.
    final TextStyle style = DefaultTextStyle.of(this).style;
    final Color? textColor = style.color;
    if (textColor != null && style.fontFamily != 'monospace') {
      return textColor.computeLuminance() > 0.5
          ? Brightness.dark
          : Brightness.light;
    }

    return MediaQuery.platformBrightnessOf(this);
  }

  /// A Flutter Theme for the SDK's routes when the app doesn't provide one,
  /// built from the brightness and font the app is actually using.
  /// Returns null when the app already has a Flutter Theme.
  ThemeData? get fallbackTheme {
    if (_hasAppTheme) return null;

    // Pushed from inside the SDK: carry the theme over to the new route.
    final HostTheme? host = findAncestorWidgetOfExactType<HostTheme>();
    if (host != null) return host.data;

    String? fontFamily = DefaultTextStyle.of(this).style.fontFamily;
    // WidgetsApp's debug error style. Seen when the context isn't under a
    // Scaffold or Material, so it says nothing about the app's font.
    if (fontFamily == 'monospace') fontFamily = null;

    return ThemeData(brightness: hostBrightness, fontFamily: fontFamily);
  }

  UserOrientColors? get _themeColors =>
      isDark ? UserOrient.theme?.dark : UserOrient.theme?.light;

  Color get backgroundColor =>
      _themeColors?.backgroundColor ??
      (isDark ? const Color(0xff1D1D1D) : Colors.white);

  Color get textColor =>
      isDark ? const Color(0xffFAFAFA) : const Color(0xff2A2A2A);
  Color get secondaryTextColor =>
      isDark ? const Color(0xffB2B2B2) : const Color(0xff8A8D8E);
  Color get borderColor =>
      isDark ? const Color(0xff262626) : const Color(0xffF2F2F2);

  Color get votedColor =>
      isDark ? const Color(0xff223027) : const Color(0xffEEFCF2);
  Color get unvotedColor =>
      isDark ? const Color(0xff2C2C2C) : const Color(0xffF7F7F7);
  Color get votedArrowColor =>
      isDark ? const Color(0xff52DF82) : const Color(0xff52DF82);

  Color get buttonColor =>
      _themeColors?.accentColor ??
      (isDark ? const Color(0xffFAFAFA) : const Color(0xff2A2A2A));

  Color get buttonTextColor =>
      buttonColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;

  Color get unvotedContainerColor => isDark
      ? const Color(0xffB2B2B2).withValues(alpha: .1)
      : const Color(0xffE9EAEE).withValues(alpha: .75);
  Color get votedContainerColor => buttonColor;

  Color get thanksColor =>
      isDark ? const Color(0xff52DF82) : const Color(0xff16A34A);

  Color get inReviewColor =>
      isDark ? const Color(0xffF5A524) : const Color(0xffB45309);
  Color get inReviewContainerColor =>
      isDark ? const Color(0xff3A2A12) : const Color(0xffFFF4E5);
  Color get completedContainerColor =>
      isDark ? const Color(0xff223027) : const Color(0xffDCF9E6);
  Color get tabsBackgroundColor =>
      isDark ? const Color(0xff121212) : const Color(0xffFAFAFA);

  Color get textFieldFillColor =>
      isDark ? const Color(0xff23252B) : const Color(0xffF1F2F3);
  Color get skeletonColor =>
      isDark ? const Color(0xff3D3D3D) : const Color(0xffE9EAEE);
}

/// The Theme the SDK wraps its routes in when the app has no Flutter Theme.
/// Its own type, so it isn't mistaken for the app's.
class HostTheme extends Theme {
  const HostTheme({super.key, required super.data, required super.child});
}
