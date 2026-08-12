import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// MotionCurve reaches us only incidentally through stupid_simple_sheet's
// exports; depend on it directly so a change there cannot break the panel.
// ignore: unnecessary_import
import 'package:motor/motor.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/sheet_dismiss.dart';

/// One motion vocabulary for the web panel: every arrival springs, every
/// departure is a plain curve.
class _PanelMotion {
  const _PanelMotion._();

  static const Duration arriveDuration = Duration(milliseconds: 440);
  static const Duration leaveDuration = Duration(milliseconds: 140);

  static const Motion arrive = CupertinoMotion.smooth(
    duration: arriveDuration,
  );

  static final Curve arriveCurve = arrive.toCurve;

  /// Written for a controller animating 0 → 1. A route's reverse runs 1 → 0
  /// and samples the curve descending, so use [leaveCurveReversed] there.
  static const Curve leaveCurve = Curves.easeOutCubic;

  static const Curve leaveCurveReversed = FlippedCurve(leaveCurve);
}

class Navigation {
  static final GlobalKey<NavigatorState> _primaryNavigatorKey =
      GlobalKey<NavigatorState>();

  /// The panel currently on screen, if any. Set by the panel itself so
  /// [push] can route into it instead of stacking another route on top.
  static _WebPanelState? _panel;

  static bool get isSheetPlatform => [
        TargetPlatform.android,
        TargetPlatform.iOS
      ].contains(defaultTargetPlatform);

  static Future<T?> push<T>(BuildContext context, Widget child) {
    if (isSheetPlatform) {
      final Route<T> route = defaultTargetPlatform == TargetPlatform.iOS
          ? StupidSimpleGlassSheetRoute<T>(
              child: child,
              backgroundColor: context.backgroundColor,
              blurBehindBarrier: false,
            )
          : StupidSimpleSheetRoute<T>(
              // Standard, not expressive: on a sheet this tall the expressive
              // tokens' overshoot reads as a rebound off the top of the screen.
              motion: const MaterialSpringMotion.standardSpatialSlow(
                snapToEnd: false,
              ),
              child: _SheetShell(
                backgroundColor: context.backgroundColor,
                child: child,
              ),
            );

      return Navigator.of(context, rootNavigator: true).push(route);
    }

    final _WebPanelState? panel = _panel;

    if (panel == null) {
      // A route rather than showDialog, so the reverse transition is ours.
      return Navigator.of(context, rootNavigator: true).push<T>(
        PageRouteBuilder<T>(
          opaque: false,
          barrierDismissible: true,
          barrierLabel: 'UserOrient',
          barrierColor: Colors.black38,
          transitionDuration: _PanelMotion.arriveDuration,
          reverseTransitionDuration: _PanelMotion.leaveDuration,
          pageBuilder: (_, __, ___) => _WebPanel(child: child),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              // Linear parent, so opacity stays in range whatever the spring
              // does. Reverse is sampled descending: opaque at 1, gone by 0.4.
              opacity: CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.35),
                reverseCurve: const Interval(0.4, 1.0),
              ),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: _PanelMotion.arriveCurve,
                    reverseCurve: _PanelMotion.leaveCurveReversed,
                  ),
                ),
                child: child,
              ),
            );
          },
        ),
      );
    }

    return panel.present<T>(context, child);
  }
}

/// Sheet chrome for Android: the plain sheet route only slides content up,
/// so the inset, the corners and the surface are ours to draw.
class _SheetShell extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const _SheetShell({
    required this.child,
    required this.backgroundColor,
  });

  static const double _radius = 28.0;
  static const double _peek = 12.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + _peek,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(_radius),
        ),
        child: ColoredBox(
          color: backgroundColor,
          // The inset is applied above; the content must not add it again.
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// The web presentation: one panel, never a stack.
///
/// The board holds the left column for the whole session; anything opened
/// from it widens the panel and takes the right column.
class _WebPanel extends StatefulWidget {
  final Widget child;

  const _WebPanel({required this.child});

  @override
  State<_WebPanel> createState() => _WebPanelState();
}

class _WebPanelState extends State<_WebPanel>
    with TickerProviderStateMixin<_WebPanel> {
  static const double _radius = _SheetShell._radius;

  static const double _primaryWidth = 480.0;
  static const double _detailWidth = 520.0;

  /// Below this the two columns would not both fit, so the detail goes back
  /// to covering the panel instead of sitting beside it.
  static const double _splitBreakpoint = 1120.0;

  /// 0 when the panel is just the board, 1 when the detail column is open.
  late final AnimationController _splitController;

  final GlobalKey<NavigatorState> _detailKey = GlobalKey<NavigatorState>();

  Widget? _detail;
  Completer<dynamic>? _detailResult;

  @override
  void initState() {
    super.initState();
    Navigation._panel = this;

    // Bounded: the width is read straight off this value, and a spring
    // overshoot would push the panel past the edge of the viewport.
    _splitController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    if (identical(Navigation._panel, this)) Navigation._panel = null;
    _splitController.dispose();
    super.dispose();
  }

  bool get _canSplit =>
      MediaQuery.sizeOf(context).width >= _splitBreakpoint &&
      MediaQuery.sizeOf(context).height >= 560;

  /// Show [child] in whichever column the caller belongs to.
  Future<T?> present<T>(BuildContext context, Widget child) {
    final NavigatorState? detail = _detailKey.currentState;

    // A push from inside the detail column stacks there — the form stepping
    // on to the email screen, not a new subject.
    if (detail != null &&
        context.findAncestorStateOfType<NavigatorState>() == detail) {
      return detail.push<T>(_detailRoute<T>(child));
    }

    if (!_canSplit) {
      return Navigation._primaryNavigatorKey.currentState!
          .push<T>(MaterialPageRoute<T>(builder: (_) => child));
    }

    // A push from the board is a new subject: replace whatever the detail
    // column was showing rather than burying it.
    if (detail != null) {
      _resolveDetail(null);
      final Completer<dynamic> completer = Completer<dynamic>();
      _detailResult = completer;

      detail.pushAndRemoveUntil<T>(_detailRoute<T>(child), (_) => false);
      setState(() => _detail = child);

      return completer.future.then((value) => value as T?);
    }

    return _openDetail<T>(child);
  }

  /// A fade, not a slide: inside a panel a horizontal push reads as the whole
  /// panel moving.
  Route<T> _detailRoute<T>(Widget child) {
    return PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 160),
      pageBuilder: (_, __, ___) => child,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  Future<T?> _openDetail<T>(Widget child) {
    final Completer<dynamic> completer = Completer<dynamic>();
    _detailResult = completer;

    setState(() => _detail = child);
    _splitController.animateTo(
      1.0,
      duration: _PanelMotion.arriveDuration,
      curve: _PanelMotion.arriveCurve,
    );

    return completer.future.then((value) => value as T?);
  }

  void _resolveDetail(dynamic result) {
    final Completer<dynamic>? completer = _detailResult;
    _detailResult = null;
    if (completer != null && !completer.isCompleted) completer.complete(result);
  }

  /// Close the detail column, or step back inside it if it has a stack.
  void _dismissDetail() {
    final NavigatorState? detail = _detailKey.currentState;

    if (detail != null && detail.canPop()) {
      detail.pop();
      return;
    }

    _resolveDetail(null);
    _splitController
        .animateTo(
      0.0,
      duration: _PanelMotion.leaveDuration,
      curve: _PanelMotion.leaveCurve,
    )
        .whenCompleteOrCancel(() {
      // Held until the collapse finishes — clearing it early would empty the
      // column and animate a blank strip shut.
      if (mounted && _splitController.value <= 0.001) {
        setState(() => _detail = null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedBuilder(
          animation: _splitController,
          builder: (context, child) {
            final double t = _splitController.value.clamp(0.0, 1.0);

            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_radius),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 48,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_radius),
                child: SizedBox(
                  width: _primaryWidth + _detailWidth * t,
                  height: double.infinity,
                  child: child,
                ),
              ),
            );
          },
          child: Row(
            children: [
              SizedBox(
                width: _primaryWidth,
                child: SheetDismiss(
                  onDismiss: () => Navigator.of(context).pop(),
                  child: Navigator(
                    key: Navigation._primaryNavigatorKey,
                    onGenerateRoute: (settings) => MaterialPageRoute(
                      builder: (_) => widget.child,
                    ),
                  ),
                ),
              ),
              if (_detail != null)
                Expanded(
                  child: ClipRect(
                    // The column keeps its full width while the panel
                    // animates, so the content never reflows mid-slide.
                    child: OverflowBox(
                      alignment: Alignment.centerLeft,
                      minWidth: _detailWidth,
                      maxWidth: _detailWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: context.borderColor),
                          ),
                        ),
                        child: SheetDismiss(
                          onDismiss: _dismissDetail,
                          child: Navigator(
                            key: _detailKey,
                            onGenerateRoute: (settings) => _detailRoute(
                              _detail!,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
