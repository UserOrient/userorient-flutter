import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/kit/host_theme.dart';
import 'package:userorient_flutter/src/support/legacy_theme.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// Every color the SDK draws with, resolved for one brightness.
///
/// Only the accent comes from the app. Everything else is fixed, so
/// surfaces, dividers and skeletons never fall out of contrast.
@immutable
class Palette {
  final bool isDark;
  final Color background;
  final Color accent;

  const Palette._({
    required this.isDark,
    required this.background,
    required this.accent,
  });

  factory Palette.resolve({
    required Brightness brightness,
    // ignore: deprecated_member_use_from_same_package
    UserOrientTheme? theme,
  }) {
    final bool isDark = brightness == Brightness.dark;
    // ignore: deprecated_member_use_from_same_package
    final UserOrientColors? colors = isDark ? theme?.dark : theme?.light;

    return Palette._(
      isDark: isDark,
      // ignore: deprecated_member_use_from_same_package
      background: colors?.backgroundColor ??
          (isDark ? const Color(0xff1D1D1D) : Colors.white),
      accent: colors?.accentColor ??
          (isDark ? const Color(0xffFAFAFA) : const Color(0xff2A2A2A)),
    );
  }

  static Palette of(BuildContext context) {
    return Palette.resolve(
      brightness: HostTheme.brightnessOf(context),
      theme: UserOrientScope.maybeOf(context)?.options.theme,
    );
  }

  Color _pick(int light, int dark) => Color(isDark ? dark : light);

  Color get text => _pick(0xff2A2A2A, 0xffFAFAFA);
  Color get secondaryText => _pick(0xff8A8D8E, 0xffB2B2B2);
  Color get border => _pick(0xffF2F2F2, 0xff262626);
  Color get field => _pick(0xffF1F2F3, 0xff23252B);
  Color get skeleton => _pick(0xffE9EAEE, 0xff3D3D3D);

  /// Readable on top of [accent], whatever the app passed.
  Color get onAccent =>
      accent.computeLuminance() < 0.5 ? Colors.white : Colors.black;

  /// Behind an unvoted arrow, and behind disabled buttons.
  Color get muted => isDark
      ? const Color(0xffB2B2B2).withValues(alpha: .1)
      : const Color(0xffE9EAEE).withValues(alpha: .75);

  Color get shipped => _pick(0xffDCF9E6, 0xff223027);
  Color get thanks => _pick(0xff16A34A, 0xff52DF82);
  Color get info => _pick(0xff2563EB, 0xff60A5FA);

  /// A sent request has no label yet, so its pill color is fixed.
  Color get inReview => _pick(0xffB45309, 0xffF5A524);
  Color get inReviewBackground => _pick(0xffFFF4E5, 0xff3A2A12);
}

extension PaletteContext on BuildContext {
  Palette get palette => Palette.of(this);
}
