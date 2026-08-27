import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/logic/user_orient_data.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/views/initializing_view.dart';

void main() {
  test('decodes a valid user sync response', () async {
    final client = MockClient(
      (_) async => http.Response('{"id":"user-id","email":null}', 200),
    );

    final user = await UserOrientData.syncUser(
      user: null,
      cachedId: null,
      projectId: 'project',
      client: client,
    );

    expect(user.id, 'user-id');
    expect(user.email, isNull);
  });

  test('rejects a malformed user sync response', () async {
    final client = MockClient(
      (_) async => http.Response('Unhandled platform error.', 200),
    );

    await expectLater(
      UserOrientData.syncUser(
        user: null,
        cachedId: null,
        projectId: 'project',
        client: client,
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a failed user sync response before decoding it', () async {
    final client = MockClient(
      (_) async => http.Response('Unhandled platform error.', 500),
    );

    await expectLater(
      UserOrientData.syncUser(
        user: null,
        cachedId: null,
        projectId: 'project',
        client: client,
      ),
      throwsA(isA<http.ClientException>()),
    );
  });

  test('times out a user sync request that never completes', () async {
    final response = Completer<http.Response>();
    final client = MockClient((_) => response.future);

    await expectLater(
      UserOrientData.syncUser(
        user: null,
        cachedId: null,
        projectId: 'project',
        client: client,
        timeout: const Duration(milliseconds: 1),
      ),
      throwsA(
        isA<http.ClientException>().having(
          (error) => error.message,
          'message',
          contains('timed out'),
        ),
      ),
    );
  });

  test(
    'returns no features when the service returns an empty response',
    () async {
      final client = MockClient((_) async => http.Response('', 200));

      final features = await UserOrientData.getFeatures(
        projectId: 'project',
        userId: 'user',
        client: client,
      );

      expect(features, isEmpty);
    },
  );

  test('returns no comments when the comments field is null', () async {
    final client = MockClient(
      (_) async => http.Response('{"comments": null}', 200),
    );

    final comments = await UserOrientData.getComments(
      projectId: 'project',
      userId: 'user',
      featureId: 'feature',
      client: client,
    );

    expect(comments, isEmpty);
  });

  test(
    'does not fetch comments before the SDK has identified the user',
    () async {
      await UserOrient.getComments(Feature.skeleton());

      expect(UserOrient.comments.value, isEmpty);
    },
  );

  testWidgets('shows feedback UI while initializing and supports retry', (
    tester,
  ) async {
    var attempts = 0;
    final firstAttempt = Completer<void>();

    Future<void> initialize() {
      attempts += 1;
      if (attempts == 1) return firstAttempt.future;
      return Future<void>.value();
    }

    await tester.pumpWidget(
      MaterialApp(
        home: InitializingView(
          initialize: initialize,
          child: const SizedBox(key: Key('feedback-board')),
        ),
      ),
    );

    expect(find.text('Loading feedback…'), findsOneWidget);

    firstAttempt.completeError(StateError('offline'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Feedback is temporarily unavailable.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump();

    expect(attempts, 2);
    expect(find.byKey(const Key('feedback-board')), findsOneWidget);
  });
}
