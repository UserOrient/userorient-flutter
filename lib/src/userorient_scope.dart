import 'package:flutter/widgets.dart';

import 'package:userorient_flutter/src/board/board_model.dart';
import 'package:userorient_flutter/src/data/session.dart';
import 'package:userorient_flutter/src/data/userorient_api.dart';
import 'package:userorient_flutter/src/stage/stage.dart';
import 'package:userorient_flutter/src/userorient_options.dart';

/// Hands the SDK's shared pieces to every screen, so no widget reaches for a
/// global. The stage re-wraps each screen it presents, since they live on
/// the app's navigator rather than under one another.
class UserOrientScope extends InheritedWidget {
  final UserOrientOptions options;
  final UserOrientApi api;
  final Session session;
  final BoardModel board;
  final Stage stage;

  const UserOrientScope({
    super.key,
    required this.options,
    required this.api,
    required this.session,
    required this.board,
    required this.stage,
    required super.child,
  });

  static UserOrientScope of(BuildContext context) {
    final UserOrientScope? scope = maybeOf(context);
    assert(scope != null, 'No UserOrientScope above this widget.');
    return scope!;
  }

  static UserOrientScope? maybeOf(BuildContext context) {
    return context.getInheritedWidgetOfExactType<UserOrientScope>();
  }

  /// The same scope around a different [child].
  UserOrientScope wrap(Widget child) {
    return UserOrientScope(
      options: options,
      api: api,
      session: session,
      board: board,
      stage: stage,
      child: child,
    );
  }

  @override
  bool updateShouldNotify(UserOrientScope oldWidget) {
    return options != oldWidget.options ||
        api != oldWidget.api ||
        session != oldWidget.session ||
        board != oldWidget.board ||
        stage != oldWidget.stage;
  }
}
