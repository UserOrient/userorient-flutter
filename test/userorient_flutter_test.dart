import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/logic/user_orient_data.dart';
import 'package:userorient_flutter/src/models/feature.dart';

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
}
