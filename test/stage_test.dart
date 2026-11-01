import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/board/board_model.dart';
import 'package:userorient_flutter/src/board/board_screen.dart';
import 'package:userorient_flutter/src/comments/comments_screen.dart';
import 'package:userorient_flutter/src/data/session.dart';
import 'package:userorient_flutter/src/data/userorient_api.dart';
import 'package:userorient_flutter/src/stage/panel_stage.dart';
import 'package:userorient_flutter/src/stage/sheet_stage.dart';
import 'package:userorient_flutter/src/stage/stage.dart';
import 'package:userorient_flutter/src/userorient_options.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

final Map<String, dynamic> _feature = {
  'id': 'f1',
  'status': 'open',
  'projectId': 'p',
  'ownerType': 'user',
  'voteCount': 3,
  'createdAt': null,
  'voted': false,
  'title': {'en': 'Dark mode'},
  'description': {'en': 'Please'},
  'labels': [],
  'commentsCount': 0,
};

UserOrientApi _api() {
  return UserOrientApi(
    projectId: 'p',
    client: MockClient((request) async {
      final String path = request.url.path;
      final Object body = switch (path) {
        '/sdk/user/sync' => {'id': 'u1'},
        '/sdk/feature/all' => {
            'features': [_feature]
          },
        '/sdk/comment/all' => {'comments': []},
        _ => {'onPaidPlan': true},
      };
      return http.Response(jsonEncode(body), 200);
    }),
  );
}

Future<void> _openBoardAndComments(WidgetTester tester, Stage stage) async {
  SharedPreferences.setMockInitialValues({});
  final UserOrientApi api = _api();
  final Session session = Session();
  final BoardModel board = BoardModel(api: api, session: session);

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () {
            board.load();
            stage.open(
              context,
              UserOrientScope(
                options: const UserOrientOptions(apiKey: 'p'),
                api: api,
                session: session,
                board: board,
                stage: stage,
                child: const BoardScreen(),
              ),
            );
          },
          child: const Text('open'),
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();

  expect(find.byType(BoardScreen), findsOneWidget);
  expect(find.text('Dark mode'), findsOneWidget);

  await tester.tap(find.text('Dark mode'));
  await tester.pumpAndSettle();

  expect(find.byType(CommentsScreen), findsOneWidget);
  expect(find.text('No comments yet'), findsOneWidget);
}

void main() {
  testWidgets('the sheet stage opens the board, then comments', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(Stage.adaptive(), isA<SheetStage>());
    await _openBoardAndComments(tester, const SheetStage());
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('the panel stage opens the board, then comments beside it',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    expect(Stage.adaptive(), isA<PanelStage>());
    await _openBoardAndComments(tester, const PanelStage());

    // Split view: the board stays next to the comments.
    expect(find.byType(BoardScreen), findsOneWidget);
    debugDefaultTargetPlatformOverride = null;
  });
}
