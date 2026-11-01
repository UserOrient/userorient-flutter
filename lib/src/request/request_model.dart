import 'package:userorient_flutter/src/board/board_model.dart';
import 'package:userorient_flutter/src/data/session.dart';
import 'package:userorient_flutter/src/data/userorient_api.dart';
import 'package:userorient_flutter/src/support/collection_mode.dart';
import 'package:userorient_flutter/src/support/log.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// Sends a feature request, and decides whether to ask for an email first.
class RequestModel {
  RequestModel({
    required this.api,
    required this.session,
    required this.board,
    required this.dataCollection,
  });

  factory RequestModel.of(UserOrientScope scope) {
    return RequestModel(
      api: scope.api,
      session: scope.session,
      board: scope.board,
      dataCollection: scope.options.dataCollection,
    );
  }

  /// Requests shorter than this are rejected before sending.
  static const int minLength = 10;
  static const int maxLength = 500;

  /// Roughly how long the request sheet takes to close.
  static const Duration revealDelay = Duration(milliseconds: 450);

  final UserOrientApi api;
  final Session session;
  final BoardModel board;
  final DataCollection dataCollection;

  /// False when the email is already known or the app opted out of it.
  bool get asksForEmail =>
      session.user?.email == null &&
      dataCollection.email != CollectionMode.notCollected;

  bool get emailRequired => dataCollection.email == CollectionMode.required;

  Future<void> send(String content, {String? email}) async {
    logUO(
      'Sending feature request: "$content" by ${email ?? '(no email provided)'} with ${session.metadata ?? 'uknown'} metadata',
      emoji: '📬',
    );

    final String? resolvedEmail = email ?? session.user?.email;

    await api.sendRequest(
      userId: await session.userId(api),
      content: content,
      email: resolvedEmail,
      metadata: session.metadata,
    );

    // Remembered, so the email step is skipped next time.
    if (resolvedEmail != null && session.user?.email == null) {
      session.adoptEmail(resolvedEmail);
    }

    // Lands once the sheet has closed, so the user sees it arrive.
    Future.delayed(revealDelay, () => board.addPending(content));

    logUO('Feature request sent. ', emoji: '🚀');
  }
}
