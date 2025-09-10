import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/models/comment.dart';

import 'package:userorient_flutter/src/models/endpoint.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/user.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/utilities/restful_endpoints.dart';

typedef UserUUID = String;

class UserOrientData {
  static Future<UserUUID> syncUser({
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

    logUO(response.body.toString(), emoji: '👀');

    return jsonDecode(response.body)['id'];
  }

  static Future<List<Feature>> getFeatures({
    required String projectId,
    required String userId,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.features(
      apiKey: projectId,
      userId: userId,
    );

    final http.Response response = await http.get(
      Uri.parse(endpoint.url),
    );

    logUO(response.body.toString(), emoji: '👀');

    // TODO: throws user not found when an old project's user has been used, sync user before, check if it exists then continue

    final List<Feature> features =
        (jsonDecode(response.body)['features'] as List)
            .map((feature) => Feature.fromJson(feature))
            .toList();

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
  }) async {
    final Endpoint endpoint = RestfulEndpoints.sendFeedback(
      projectId: projectId,
      content: content,
      userId: userId,
    );

    await http.post(
      Uri.parse(endpoint.url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(endpoint.body),
    );
  }

  static Future<UserUUID> resolveUserUuid({
    required String projectId,
    required User? user,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cachedUuid = prefs.getString('user_orient_user_uuid');

    if (cachedUuid != null) {
      logUO('Found cached UUID: $cachedUuid', emoji: '🔍');

      UserOrientData.syncUser(
        user: user,
        projectId: projectId,
        cachedId: cachedUuid,
      ).ignore();

      return cachedUuid;
    } else {
      final UserUUID uuid = await UserOrientData.syncUser(
        user: user,
        cachedId: null,
        projectId: projectId,
      );

      await prefs.setString('user_orient_user_uuid', uuid);

      logUO('Acquired a new UUID: $uuid', emoji: '🆕');

      return uuid;
    }
  }

  static Future<List<Comment>> getComments({
    required String projectId,
    required String userId,
    required String featureId,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.comments(
      projectId: projectId,
      userId: userId,
      featureId: featureId,
    );

    logUO(endpoint.url, emoji: '👀');

    final http.Response response = await http.get(
      Uri.parse(endpoint.url),
    );

    logUO(response.body.toString(), emoji: '👀');

    return (jsonDecode(response.body)['comments'] as List).map((comment) {
      return Comment.fromJson(comment);
    }).toList();
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
