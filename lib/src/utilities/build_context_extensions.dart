import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get backgroundColor => isDark ? const Color(0xff1D1D1D) : Colors.white;
  Color get textColor =>
      isDark ? const Color(0xffFAFAFA) : const Color(0xff2A2A2A);
  Color get secondaryTextColor =>
      isDark ? const Color(0xffB2B2B2) : const Color(0xffACAEAF);
  Color get borderColor =>
      isDark ? const Color(0xff303030) : const Color(0xffF2F2F2);

  Color get votedColor =>
      isDark ? const Color(0xff223027) : const Color(0xffEEFCF2);
  Color get unvotedColor =>
      isDark ? const Color(0xff2C2C2C) : const Color(0xffF7F7F7);
  Color get votedArrowColor =>
      isDark ? const Color(0xff52DF82) : const Color(0xff52DF82);
  Color get buttonColor =>
      isDark ? const Color(0xffFAFAFA) : const Color(0xff2A2A2A);
  Color get buttonTextColor => isDark ? const Color(0xff1D1D1D) : Colors.white;
  Color get unvotedContainerColor => isDark
      ? const Color(0xffB2B2B2).withValues(alpha: .1)
      : const Color(0xffE9EAEE).withValues(alpha: .75);
  Color get votedContainerColor =>
      isDark ? Colors.white.withValues(alpha: .75) : const Color(0xff2F313F);
  Color get completedContainerColor =>
      isDark ? const Color(0xff223027) : const Color(0xffDCF9E6);
  Color get tabsBackgroundColor =>
      isDark ? const Color(0xff121212) : const Color(0xffFAFAFA);
  Color get textFieldFillColor =>
      isDark ? const Color(0xff2A2A2A) : const Color(0xffFAFAFA);
}
