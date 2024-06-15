import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:userorient_flutter/src/models/endpoint.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/project.dart';
import 'package:userorient_flutter/src/models/user.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/utilities/restful_endpoints.dart';

typedef UserUUID = String;

class UserOrientData {
  static Future<UserUUID> syncUser({
    required User user,
    required String projectId,
  }) async {
    final Endpoint endpoint = RestfulEndpoints.syncUser(projectId);

    logUO('Syncing user: ${user.toJson()}', emoji: '🔄');

    final http.Response response = await http.post(
      Uri.parse(endpoint.url),
      body: jsonEncode(user.toJson()),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return jsonDecode(response.body)['id'];
  }

  static Future<Project> getProjectDetails(String projectId) async {
    final Endpoint endpoint = RestfulEndpoints.projectDetails(projectId);

    final http.Response response = await http.get(
      Uri.parse(endpoint.url),
    );

    return Project.fromJson(
      jsonDecode(response.body)['project'],
    );
  }

  static Future<List<Feature>> getFeedbacks({
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
    required User user,
  }) async {
    UserUUID uuid;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cachedUuid = prefs.getString('user_orient_uuid');
    logUO('Cached UUID: $cachedUuid', emoji: '🔍');

    if (cachedUuid != null) {
      uuid = cachedUuid;

      await UserOrientData.syncUser(
        user: user,
        projectId: projectId,
      );
    } else {
      uuid = await UserOrientData.syncUser(
        user: user,
        projectId: projectId,
      );

      logUO('Acquired a UUID for user $uuid', emoji: '🆕');

      await prefs.setString('user_orient_uuid', uuid);
    }

    return uuid;
  }

  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_orient_uuid');
  }
}
