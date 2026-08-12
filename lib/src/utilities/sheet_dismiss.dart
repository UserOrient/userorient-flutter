import 'package:flutter/material.dart';

/// How a screen closes itself, decided by whoever is presenting it.
class SheetDismiss extends InheritedWidget {
  final VoidCallback onDismiss;

  const SheetDismiss({
    super.key,
    required this.onDismiss,
    required super.child,
  });

  /// The nearest dismissal, or a plain pop when nothing is presenting.
  static VoidCallback of(BuildContext context) {
    final SheetDismiss? scope =
        context.dependOnInheritedWidgetOfExactType<SheetDismiss>();

    if (scope != null) return scope.onDismiss;

    return () {
      final NavigatorState navigator = Navigator.of(context);

      // Sheets are pushed on the root navigator, so a nested one may have
      // nothing of its own to pop.
      if (navigator.canPop()) {
        navigator.pop();
      } else {
        Navigator.of(context, rootNavigator: true).pop();
      }
    };
  }

  @override
  bool updateShouldNotify(SheetDismiss oldWidget) {
    return onDismiss != oldWidget.onDismiss;
  }
}
