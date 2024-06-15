import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/project.dart';
import 'package:userorient_flutter/src/logic/user_orient_data.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/views/board_view.dart';
import 'package:userorient_flutter/src/views/form_view.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

class UserOrient {
  static final ValueNotifier<List<Feature>?> features = ValueNotifier(null);
  static final ValueNotifier<User?> user = ValueNotifier(null);
  static final ValueNotifier<Project?> project = ValueNotifier(null);

  // Configurations
  static String? _apiKey;
  static User? _user;
  static UserUUID? userUuid;
  static bool _hardReset = false;

  static bool _isInitialized = false;
  static void markInitialized() {
    _isInitialized = true;
  }

  /// Open the UserOrient board view
  static Future<void> openBoard(BuildContext context) {
    return _open(
      context: context,
      child: const BoardView(),
    );
  }

  /// Open the UserOrient feature request form
  static Future<void> openForm(BuildContext context) {
    return _open(
      context: context,
      child: const FormView(),
    );
  }

  static Future<void> _open({
    required BuildContext context,
    required Widget child,
  }) async {
    _initialize();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'UserOrient',
      transitionDuration: kThemeAnimationDuration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return child;
      },
    );
  }

  /// Configure the UserOrient SDK. This method must be called before using the SDK.
  ///
  /// [apiKey] is the API Key from the UserOrient dashboard.
  /// [user] is the user information. By default, it is an anonymous user.
  /// [hardReset] should be set to true if you use multiple boards in the same app.
  static void configure({
    required String apiKey,
    User? user = const User.anonymous(),
    bool hardReset = false,
  }) {
    _apiKey = apiKey;
    _user = user;
    _hardReset = hardReset;
  }

  static Future<void> logout() async {
    await UserOrientData.logout();

    _isInitialized = false;
    _apiKey = null;
    _user = null;
    userUuid = null;

    features.value = null;

    logUO('Logged out', emoji: '🚪');
  }

  static Future<void> _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cachedProjectId = prefs.getString('user_orient_project_id');
    final bool projectChanged = cachedProjectId != _apiKey;
    if (projectChanged) {
      logUO('Project changed, reinitializing', emoji: '🔄');
    }

    if (_hardReset || projectChanged) {
      prefs.remove('user_orient_uuid');
      prefs.remove('user_orient_project_id');

      features.value = null;
      project.value = null;

      _isInitialized = false;

      logUO('Hard reset performed', emoji: '🔥');
    }

    if (_isInitialized) {
      logUO('SDK already initialized, continue', emoji: '🤓');
    } else {
      logUO('Initializing the SDK', emoji: '🚁');

      if (_user == null || _apiKey == null) {
        throw 'Call `UserOrient.configure()` method before using the SDK';
      }

      userUuid = await UserOrientData.resolveUserUuid(
        projectId: _apiKey!,
        user: _user!,
      );

      UserOrient.user.value = _user;

      final List<dynamic> results = await Future.wait([
        UserOrientData.getProjectDetails(_apiKey!),
        UserOrientData.getFeedbacks(projectId: _apiKey!, userId: userUuid!),
      ]);

      project.value = results[0];

      final List<Feature> features = results[1];
      UserOrient.features.value = features;

      markInitialized();

      logUO(
        'Initialization completed for "${project.value?.name}"',
        emoji: '✅',
      );

      prefs.setString('user_orient_project_id', _apiKey!);
    }

    logUO('User UUID: $userUuid', emoji: '🔗');
    logUO('Project name: ${project.value?.name}, id: ${project.value?.id}',
        emoji: '📦');
  }

  /// Toggle the upvote status of a feature. Used internally by the SDK.
  static Future<void> toggleUpvote(Feature feature) async {
    final List<Feature> updatedFeatures = UserOrient.features.value!.map((f) {
      if (f.id == feature.id) {
        return feature.copyWith(
          voted: !feature.voted,
          voteCount:
              feature.voted ? feature.voteCount - 1 : feature.voteCount + 1,
        );
      }

      return f;
    }).toList();

    UserOrient.features.value = updatedFeatures;

    await UserOrientData.toggleUpvote(
      projectId: _apiKey!,
      userId: userUuid!,
      feature: feature,
    );

    logUO(
      !feature.voted ? 'Upvoted' : 'Removed upvote',
      emoji: !feature.voted ? '👍' : '😶‍🌫️',
    );
  }

  /// Submit a feature request. Used internally by the SDK.
  static Future<void> submitForm({
    required String content,
  }) async {
    logUO('Sending feature request', emoji: '📬');

    await UserOrientData.sendFeatureRequest(
      projectId: _apiKey!,
      userId: userUuid!,
      content: content,
    );

    logUO('Feature request sent', emoji: '🚀');
  }

  /// Checks if the SDK is launched for the first time
  static Future<bool> isFirstLaunch() async {
    final Directory directory = Directory.systemTemp;

    final File file = File('${directory.path}/user_orient_first_launch');
    if (await file.exists()) {
      return false;
    }

    await file.writeAsString('true');

    return true;
  }
}
