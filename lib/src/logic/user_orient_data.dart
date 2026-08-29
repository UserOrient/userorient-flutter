import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/models/comment.dart';
import 'package:userorient_flutter/src/models/endpoint.dart';
import 'package:userorient_flutter/src/models/project.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/user.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/utilities/restful_endpoints.dart';

typedef UserUUID = String;

class ResolvedUser {
  final String id;
  final String? email;

  const ResolvedUser({required this.id, this.email});
}

class UserOrientData {
  static Future<ResolvedUser> syncUser({
    required User? user,
    required String? cachedId,
    required String projectId,
  }) async {
    user ??= const User.anonymous();
    final Endpoint endpoint = RestfulEndpoints.syncUser(projectId);

    logUO('Syncing user: ${user.toJson(cachedId)}', emoji: '🔄');

    final http.Response response = await http.post(
      Uri.parse(endpoint.url),
      body: jsonEncode(user.toJson(cachedId)),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    logUO('Authenticated user: ${response.body}', emoji: '👀');

    final body = jsonDecode(response.body);
    return ResolvedUser(id: body['id'], email: body['email']);
  }

  static Future<Project> getProject({required String projectId}) async {
    final Endpoint endpoint = RestfulEndpoints.projectDetails(projectId);
    final http.Response response = await http.get(Uri.parse(endpoint.url));

    return Project.fromJson(jsonDecode(response.body));
  }

  static Future<List<Feature>> getFeatures({
    required String projectId,
    required String userId,
    http.Client? client,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.features(
      apiKey: projectId,
      userId: userId,
    );

    final http.Response response =
        await (client?.get(Uri.parse(endpoint.url)) ??
            http.get(Uri.parse(endpoint.url)));

    logUO(response.body.toString(), emoji: '👀');

    // TODO: throws user not found when an old project's user has been used, sync user before, check if it exists then continue

    final List<Feature> features = _decodeObjectList(
      response.body,
      field: 'features',
    ).map(Feature.fromJson).toList();

    features.sort((a, b) => b.voteCount.compareTo(a.voteCount));

    return features;
  }

  static Future<void> toggleUpvote({
    required String projectId,
    required String userId,
    required Feature feature,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.toggleUpvote(
      projectId: projectId,
      userId: userId,
      featureId: feature.id,
    );

    await http.post(
      Uri.parse(endpoint.url),
      body: jsonEncode(endpoint.body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<void> sendFeatureRequest({
    required String projectId,
    required String userId,
    required String content,
    required String? email,
    required Map<String, dynamic>? metaData,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.sendFeedback(
      projectId: projectId,
      content: content,
      userId: userId,
      email: email,
      metaData: metaData,
    );

    await http.post(
      Uri.parse(endpoint.url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(endpoint.body),
    );
  }

  static Future<ResolvedUser> resolveUserUuid({
    required String projectId,
    required User? user,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedUuid = prefs.getString('user_orient_user_uuid');

    if (cachedUuid != null) {
      logUO('Found cached UUID: $cachedUuid', emoji: '🔍');

      final result = await UserOrientData.syncUser(
        user: user,
        projectId: projectId,
        cachedId: cachedUuid,
      );

      return ResolvedUser(id: cachedUuid, email: result.email);
    } else {
      final result = await UserOrientData.syncUser(
        user: user,
        cachedId: null,
        projectId: projectId,
      );

      await prefs.setString('user_orient_user_uuid', result.id);

      logUO('Acquired a new UUID: ${result.id}', emoji: '🆕');

      return result;
    }
  }

  static Future<List<Comment>> getComments({
    required String projectId,
    required String userId,
    required String featureId,
    http.Client? client,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.comments(
      projectId: projectId,
      userId: userId,
      featureId: featureId,
    );

    logUO(endpoint.url, emoji: '👀');

    final http.Response response =
        await (client?.get(Uri.parse(endpoint.url)) ??
            http.get(Uri.parse(endpoint.url)));

    logUO(response.body.toString(), emoji: '👀');

    return _decodeObjectList(
      response.body,
      field: 'comments',
    ).map(Comment.fromJson).toList();
  }

  static List<Map<String, dynamic>> _decodeObjectList(
    String responseBody, {
    required String field,
  }) {
    if (responseBody.trim().isEmpty) return const [];

    try {
      final decoded = jsonDecode(responseBody);
      if (decoded is! Map<String, dynamic>) return const [];

      final value = decoded[field];
      if (value is! List) return const [];

      return value.whereType<Map<String, dynamic>>().toList(growable: false);
    } on FormatException {
      return const [];
    }
  }

  static Future<void> addComment({
    required String projectId,
    required String userId,
    required String featureId,
    required String content,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.addComment(
      projectId: projectId,
      userId: userId,
      featureId: featureId,
      content: content,
    );

    logUO('Body: ${endpoint.body}', emoji: '👀');
    logUO('URL: ${endpoint.url}', emoji: '👀');
    logUO('Method: ${endpoint.method}', emoji: '👀');

    final http.Response response = await http.post(
      Uri.parse(endpoint.url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(endpoint.body),
    );

    logUO(response.body.toString(), emoji: '👀');
  }
}
