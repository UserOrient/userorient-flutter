import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stupid_simple_sheet/stupid_simple_sheet.dart';

import 'package:userorient_flutter/src/stage/stage.dart';

/// Phones: every screen is its own sheet, stacked on the app's root
/// navigator. A glass sheet on iOS, a spring sheet on Android.
class SheetStage extends Stage {
  const SheetStage();

  /// Shared with the panel, so both presentations round the same.
  static const double cornerRadius = 28.0;

  @override
  Future<T?> present<T>(
    BuildContext context,
    Widget screen,
    Backdrop backdrop,
  ) {
    final Color background = backdrop.palette.background;

    final Route<T> route = defaultTargetPlatform == TargetPlatform.iOS
        ? StupidSimpleGlassSheetRoute<T>(
            backgroundColor: background,
            blurBehindBarrier: false,
            child: backdrop(screen),
          )
        : StupidSimpleSheetRoute<T>(
            // Standard, not expressive: on a sheet this tall the expressive
            // tokens' overshoot reads as a rebound off the top of the screen.
            motion: const MaterialSpringMotion.standardSpatialSlow(
              snapToEnd: false,
            ),
            child: _SheetShell(
              background: background,
              child: backdrop(screen),
            ),
          );

    return Navigator.of(context, rootNavigator: true).push(route);
  }
}

/// Sheet chrome for Android: the plain sheet route only slides content up,
/// so the inset, the corners and the surface are ours to draw.
class _SheetShell extends StatelessWidget {
  final Widget child;
  final Color background;

  const _SheetShell({required this.child, required this.background});

  static const double _peek = 12.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + _peek,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SheetStage.cornerRadius),
        ),
        child: ColoredBox(
          color: background,
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
