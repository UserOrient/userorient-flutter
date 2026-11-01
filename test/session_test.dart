import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/data/session.dart';
import 'package:userorient_flutter/src/data/user.dart';
import 'package:userorient_flutter/src/data/userorient_api.dart';

const String _projectKey = 'user_orient_project_id';
const String _userIdKey = 'user_orient_user_uuid';

/// A backend that answers every sync with [id] and [email], and records
/// what it was sent.
class _FakeBackend {
  _FakeBackend({this.id = 'server-id', this.email});

  final String id;
  final String? email;
  final List<http.Request> syncs = [];
  bool fail = false;

  UserOrientApi api(String projectId) {
    return UserOrientApi(
      projectId: projectId,
      client: MockClient((request) async {
        syncs.add(request);
        if (fail) throw http.ClientException('offline');
        return http.Response(jsonEncode({'id': id, 'email': email}), 200);
      }),
    );
  }

  Map<String, dynamic> lastBody() => jsonDecode(syncs.last.body);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a new device gets an id from the server and keeps it', () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend(id: 'new-id');
    final Session session = Session();

    final String id = await session.userId(backend.api('project-a'));

    expect(id, 'new-id');
    expect(backend.syncs.single.url.toString(),
        'https://api.userorient.com/sdk/user/sync?projectId=project-a');
    expect(backend.lastBody()['id'], isNull);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(_userIdKey), 'new-id');
    expect(prefs.getString(_projectKey), 'project-a');
  });

  test('a known device keeps its stored id, whatever the server returns',
      () async {
    SharedPreferences.setMockInitialValues({
      _userIdKey: 'stored-id',
      _projectKey: 'project-a',
    });
    final _FakeBackend backend = _FakeBackend(id: 'other-id');
    final Session session = Session();

    final String id = await session.userId(backend.api('project-a'));

    expect(id, 'stored-id');
    expect(backend.lastBody()['id'], 'stored-id');
    expect(backend.lastBody()['userId'], 'stored-id');
  });

  test('the identified user is sent with the sync', () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend();
    final Session session = Session()
      ..user = const User(
        uniqueIdentifier: '123',
        fullName: 'Ada',
        email: 'ada@example.com',
        isPaying: true,
      );

    await session.userId(backend.api('project-a'));

    final Map<String, dynamic> body = backend.lastBody();
    expect(body['uniqueIdentifier'], '123');
    expect(body['fullName'], 'Ada');
    expect(body['email'], 'ada@example.com');
    expect(body['extra'], {'isPaying': true});
  });

  test('extra is sent alongside isPaying', () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend();
    final Session session = Session()
      ..user = const User(isPaying: true, extra: {'plan': 'pro', 'seats': 4});

    await session.userId(backend.api('project-a'));

    expect(backend.lastBody()['extra'], {
      'plan': 'pro',
      'seats': 4,
      'isPaying': true,
    });
  });

  test('no extra is sent as null, so stored extra is kept', () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend();
    final Session session = Session();

    await session.userId(backend.api('project-a'));

    expect(backend.lastBody().containsKey('extra'), isTrue);
    expect(backend.lastBody()['extra'], isNull);
  });

  test('an email the server knows is adopted when the app gave none', () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend(email: 'known@example.com');
    final Session session = Session();

    await session.userId(backend.api('project-a'));

    expect(session.user?.email, 'known@example.com');
  });

  test("the app's own email wins over the server's", () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend(email: 'server@example.com');
    final Session session = Session()..user = const User(email: 'app@x.com');

    await session.userId(backend.api('project-a'));

    expect(session.user?.email, 'app@x.com');
  });

  test('the id is resolved once per run', () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend();
    final Session session = Session();
    final UserOrientApi api = backend.api('project-a');

    await Future.wait([session.userId(api), session.userId(api)]);
    await session.userId(api);

    expect(backend.syncs, hasLength(1));
  });

  test('a different project starts from a fresh id', () async {
    SharedPreferences.setMockInitialValues({
      _userIdKey: 'old-id',
      _projectKey: 'project-a',
    });
    final _FakeBackend backend = _FakeBackend(id: 'fresh-id');
    final Session session = Session();

    final String id = await session.userId(backend.api('project-b'));

    expect(id, 'fresh-id');
    expect(backend.lastBody()['id'], isNull);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(_userIdKey), 'fresh-id');
    expect(prefs.getString(_projectKey), 'project-b');
  });

  test('clear forgets the stored id but keeps the user', () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend();
    final Session session = Session()..user = const User(fullName: 'Ada');
    final UserOrientApi api = backend.api('project-a');

    await session.userId(api);
    await session.clear();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(_userIdKey), isNull);
    expect(prefs.getString(_projectKey), isNull);
    expect(session.user?.fullName, 'Ada');

    await session.userId(api);
    expect(backend.syncs, hasLength(2));
  });

  test('a failed sync is retried on the next call', () async {
    SharedPreferences.setMockInitialValues({});
    final _FakeBackend backend = _FakeBackend()..fail = true;
    final Session session = Session();
    final UserOrientApi api = backend.api('project-a');

    await expectLater(
        session.userId(api), throwsA(isA<http.ClientException>()));

    backend.fail = false;
    expect(await session.userId(api), 'server-id');
  });
}
