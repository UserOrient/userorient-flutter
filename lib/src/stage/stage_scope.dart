import 'package:flutter/widgets.dart';

/// How the screens below it close, set by whichever stage presents them.
class StageScope extends InheritedWidget {
  final VoidCallback onDismiss;

  const StageScope({
    super.key,
    required this.onDismiss,
    required super.child,
  });

  /// The nearest dismissal, or a plain pop when no stage set one.
  static VoidCallback dismissOf(BuildContext context) {
    final StageScope? scope =
        context.dependOnInheritedWidgetOfExactType<StageScope>();

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
  bool updateShouldNotify(StageScope oldWidget) {
    return onDismiss != oldWidget.onDismiss;
  }
}
