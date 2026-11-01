import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:userorient_flutter/src/data/comment.dart';
import 'package:userorient_flutter/src/data/feature.dart';
import 'package:userorient_flutter/src/data/project.dart';
import 'package:userorient_flutter/src/data/user.dart';
import 'package:userorient_flutter/src/support/log.dart';

/// Who the server says the user is.
class SyncedUser {
  final String id;
  final String? email;

  const SyncedUser({required this.id, this.email});
}

/// Every call the SDK makes to the UserOrient backend, for one project.
class UserOrientApi {
  UserOrientApi({required this.projectId, http.Client? client})
      : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.userorient.com/sdk';
  static const Map<String, String> _json = {'Content-Type': 'application/json'};

  /// The API key from the UserOrient dashboard.
  final String projectId;
  final http.Client _client;

  /// Registers [user] (anonymous when null) and returns the server's id for
  /// them. [knownId] is the id this device already has, if any.
  Future<SyncedUser> syncUser(User? user, {String? knownId}) async {
    user ??= const User.anonymous();

    logUO('Syncing user: ${user.toJson(knownId)}', emoji: '🔄');

    final http.Response response = await _client.post(
      _url('user/sync'),
      body: jsonEncode(user.toJson(knownId)),
      headers: _json,
    );

    logUO('Authenticated user: ${response.body}', emoji: '👀');

    final body = jsonDecode(response.body);
    return SyncedUser(id: body['id'], email: body['email']);
  }

  Future<Project> fetchProject() async {
    final http.Response response = await _client.get(_url('project/details'));

    return Project.fromJson(jsonDecode(response.body));
  }

  /// Every feature on the board, most voted first.
  Future<List<Feature>> fetchFeatures({required String userId}) async {
    final http.Response response = await _client.get(
      _url('feature/all', {'userId': userId}),
    );

    logUO(response.body, emoji: '👀');

    final List<Feature> features =
        (jsonDecode(response.body)['features'] as List)
            .map((feature) => Feature.fromJson(feature))
            .toList();

    features.sort((a, b) => b.voteCount.compareTo(a.voteCount));

    return features;
  }

  Future<void> toggleVote({
    required String userId,
    required String featureId,
  }) async {
    await _client.post(
      _url('feature/toggle'),
      body: jsonEncode({'userId': userId, 'featureId': featureId}),
      headers: _json,
    );
  }

  Future<void> sendRequest({
    required String userId,
    required String content,
    required String? email,
    required Map<String, dynamic>? metadata,
  }) async {
    await _client.post(
      _url('feedback'),
      headers: _json,
      body: jsonEncode({
        'userId': userId,
        'email': email,
        'description': {'en': content},
        'metaData': metadata,
      }),
    );
  }

  Future<List<Comment>> fetchComments({
    required String userId,
    required String featureId,
  }) async {
    final http.Response response = await _client.get(
      _url('comment/all', {'userId': userId, 'featureId': featureId}),
    );

    logUO(response.body, emoji: '👀');

    return (jsonDecode(response.body)['comments'] as List)
        .map((comment) => Comment.fromJson(comment))
        .toList();
  }

  Future<void> addComment({
    required String userId,
    required String featureId,
    required String content,
  }) async {
    final http.Response response = await _client.post(
      _url('comment'),
      headers: _json,
      body: jsonEncode({
        'userId': userId,
        'featureId': featureId,
        'content': content,
      }),
    );

    logUO(response.body, emoji: '👀');
  }

  /// `projectId` always goes first, matching what the backend has always
  /// received.
  Uri _url(String path, [Map<String, String> query = const {}]) {
    return Uri.parse('$_baseUrl/$path').replace(
      queryParameters: {'projectId': projectId, ...query},
    );
  }
}
