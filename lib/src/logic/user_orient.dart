import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/project.dart';
import 'package:userorient_flutter/src/logic/user_orient_data.dart';
import 'package:userorient_flutter/src/models/user.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/views/board_view.dart';
import 'package:userorient_flutter/src/views/form_view.dart';

class UserOrient {
  static final ValueNotifier<List<Feature>?> features = ValueNotifier(null);
  static final ValueNotifier<User?> user = ValueNotifier(null);
  static final ValueNotifier<Project?> project = ValueNotifier(null);

  static String? _apiKey;
  static User? _user;
  static UserUUID? userUuid;
  static bool _isInitialized = false;

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
  /// [hardReset] should be set to true if you use multiple boards in the same app.
  static void configure({
    required String apiKey,
  }) {
    _apiKey = apiKey;
  }

  static void setUser({
    String? uniqueIdentifier,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? language,
    Map<String, dynamic>? extra,
  }) {
    final User user = User(
      uniqueIdentifier: uniqueIdentifier,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      language: language,
      extra: extra,
    );

    _user = user;
  }

  static Future<void> clearCache() async {
    await UserOrientData.clearCache();

    _isInitialized = false;
    _apiKey = null;
    _user = null;
    userUuid = null;

    features.value = null;

    logUO('Cache cleared', emoji: '🆑');
  }

  static Future<void> _initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cachedProjectId = prefs.getString('user_orient_project_id');
    final bool hasProjectId = cachedProjectId != null;
    final bool projectChanged = hasProjectId && cachedProjectId != _apiKey;

    if (projectChanged) {
      await prefs.remove('user_orient_project_id');
      await clearCache();

      logUO('Project changed, cache cleared...', emoji: '🔄');
    }

    if (_isInitialized) {
      logUO('SDK already initialized, continue', emoji: '🤓');
    } else {
      logUO('Initializing the SDK', emoji: '🚁');

      if (_apiKey == null) {
        throw 'Call `UserOrient.configure()` method before using the SDK';
      }

      userUuid = await UserOrientData.resolveUserUuid(
        projectId: _apiKey!,
        user: _user!,
      );

      UserOrient.user.value = _user;

      final List<dynamic> results = await Future.wait([
        UserOrientData.getProjectDetails(_apiKey!),
        UserOrientData.getFeatures(projectId: _apiKey!, userId: userUuid!),
      ]);

      project.value = results[0];

      final List<Feature> features = results[1];
      UserOrient.features.value = features;

      _isInitialized = true;

      logUO(
        'Initialization completed for "${project.value?.name}"',
        emoji: '✅',
      );

      prefs.setString('user_orient_project_id', _apiKey!);
    }

    logUO('User UUID: $userUuid', emoji: '🔗');
    logUO(
      'Project name: ${project.value?.name}, id: ${project.value?.id}',
      emoji: '📦',
    );
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
}
