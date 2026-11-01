import 'dart:async';

import 'package:flutter/material.dart';
// MotionCurve reaches us only incidentally through stupid_simple_sheet's
// exports; depend on it directly so a change there cannot break the panel.
// ignore: unnecessary_import
import 'package:motor/motor.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/stage/sheet_stage.dart';
import 'package:userorient_flutter/src/stage/stage.dart';
import 'package:userorient_flutter/src/stage/stage_scope.dart';

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

/// Web and desktop: one panel docked to the right, never a stack.
///
/// The board holds the left column; anything opened from it widens the panel
/// and takes a right column, or covers the board when the window is narrow.
class PanelStage extends Stage {
  const PanelStage();

  @override
  Future<T?> present<T>(
    BuildContext context,
    Widget screen,
    Backdrop backdrop,
  ) {
    // Already inside the panel: it decides which column the screen takes.
    final _PanelState? panel = context.findAncestorStateOfType<_PanelState>();
    if (panel != null) return panel.present<T>(context, screen);

    // A route rather than showDialog, so the reverse transition is ours.
    return Navigator.of(context, rootNavigator: true).push<T>(
      PageRouteBuilder<T>(
        opaque: false,
        barrierDismissible: true,
        barrierLabel: 'UserOrient',
        barrierColor: Colors.black38,
        transitionDuration: _PanelMotion.arriveDuration,
        reverseTransitionDuration: _PanelMotion.leaveDuration,
        // The panel's own chrome needs the backdrop too, not just the
        // screens inside it.
        pageBuilder: (_, __, ___) => backdrop(_Panel(child: screen)),
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
}

class _Panel extends StatefulWidget {
  final Widget child;

  const _Panel({required this.child});

  @override
  State<_Panel> createState() => _PanelState();
}

class _PanelState extends State<_Panel> with TickerProviderStateMixin<_Panel> {
  static const double _radius = SheetStage.cornerRadius;

  static const double _primaryWidth = 480.0;
  static const double _detailWidth = 520.0;

  /// Below this the two columns would not both fit, so the detail goes back
  /// to covering the panel instead of sitting beside it.
  static const double _splitBreakpoint = 1120.0;

  /// 0 when the panel is just the board, 1 when the detail column is open.
  late final AnimationController _splitController;

  final GlobalKey<NavigatorState> _primaryKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _detailKey = GlobalKey<NavigatorState>();

  Widget? _detail;
  Completer<dynamic>? _detailResult;

  @override
  void initState() {
    super.initState();

    // Bounded: the width is read straight off this value, and a spring
    // overshoot would push the panel past the edge of the viewport.
    _splitController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
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
      return _primaryKey.currentState!
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
                child: StageScope(
                  onDismiss: () => Navigator.of(context).pop(),
                  child: Navigator(
                    key: _primaryKey,
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
                            left: BorderSide(color: context.palette.border),
                          ),
                        ),
                        child: StageScope(
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
