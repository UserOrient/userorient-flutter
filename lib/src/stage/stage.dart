import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/kit/host_theme.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/l10n/locale_scope.dart';
import 'package:userorient_flutter/src/stage/panel_stage.dart';
import 'package:userorient_flutter/src/stage/sheet_stage.dart';
import 'package:userorient_flutter/src/stage/stage_scope.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// Where the SDK's screens appear on top of the app.
///
/// Screens never touch a Navigator. They ask the stage to [push] the next
/// screen and to [dismiss] themselves, and the stage decides what that
/// means: a sheet on phones, a side panel on web and desktop. A new way of
/// presenting is a new subclass, with nothing else changing.
abstract class Stage {
  const Stage();

  /// Sheets on touch platforms, the panel everywhere else.
  factory Stage.adaptive() {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android || TargetPlatform.iOS => const SheetStage(),
      _ => const PanelStage(),
    };
  }

  /// The stage presenting the screen [context] belongs to.
  static Stage of(BuildContext context) => UserOrientScope.of(context).stage;

  /// Closes the screen [context] belongs to.
  static void dismiss(BuildContext context) => StageScope.dismissOf(context)();

  /// Shows [root] over the app, from the app's own [context].
  Future<T?> open<T>(BuildContext context, UserOrientScope root) {
    return present<T>(context, root.child, Backdrop.of(context, root));
  }

  /// Shows [screen] on top of the screen [context] belongs to.
  Future<T?> push<T>(BuildContext context, Widget screen) {
    final UserOrientScope scope = UserOrientScope.of(context);
    return present<T>(context, screen, Backdrop.of(context, scope));
  }

  /// Puts [screen] on screen. [backdrop] wraps it in everything a screen
  /// expects above it, since it lands on the app's navigator, outside the
  /// SDK's tree.
  @protected
  Future<T?> present<T>(BuildContext context, Widget screen, Backdrop backdrop);
}

/// What every presented screen sits on: the SDK's scope, its language and,
/// for apps without a Flutter Theme, the theme it falls back to.
@immutable
class Backdrop {
  final UserOrientScope _scope;
  final ThemeData? _fallbackTheme;

  /// Resolved from the presenting context, for chrome drawn outside
  /// [call], like the sheet's surface.
  final Palette palette;

  const Backdrop._(this._scope, this._fallbackTheme, this.palette);

  factory Backdrop.of(BuildContext context, UserOrientScope scope) {
    final ThemeData? fallbackTheme = HostTheme.fallbackOf(context);

    return Backdrop._(
      scope,
      fallbackTheme,
      Palette.resolve(
        brightness:
            fallbackTheme?.brightness ?? HostTheme.brightnessOf(context),
        theme: scope.options.theme,
      ),
    );
  }

  Widget call(Widget child) {
    final Widget scoped = _scope.wrap(LocaleScope(child: child));
    final ThemeData? theme = _fallbackTheme;

    return theme == null ? scoped : HostTheme(data: theme, child: scoped);
  }
}
