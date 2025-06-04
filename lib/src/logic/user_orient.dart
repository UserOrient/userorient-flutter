import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient_data.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/user.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/utilities/navigation.dart';
import 'package:userorient_flutter/src/views/board_view.dart';
import 'package:userorient_flutter/src/views/form_view.dart';

class UserOrient {
  static final ValueNotifier<List<Feature>?> features = ValueNotifier(null);

  static String? _apiKey;
  static User? user;
  static UserUUID? userUuid;
  static bool _isInitialized = false;
  static String languageCode = 'en';

  /// Open the UserOrient board view
  static Future<void> openBoard(BuildContext context) {
    return Navigation.push(context, const BoardView());
  }

  /// Open the UserOrient feature request form
  static Future<void> openForm(BuildContext context) {
    return Navigation.push(context, const FormView());
  }

  /// Configure the UserOrient SDK. This method must be called before using the SDK.
  ///
  /// [apiKey] is the API Key from the UserOrient dashboard.
  /// [languageCode] is the language code for the user's language.
  static void configure({
    required String apiKey,
    required String languageCode,
  }) {
    /// Ignore the language code if it's not English
    if (L10n.isSupportedLanguage(languageCode)) {
      UserOrient.languageCode = languageCode.toLowerCase();
    }

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

    UserOrient.user = user;
    initialize().ignore();
    logUO('Set user', emoji: '👤');
  }

  static Future<void> clearCache() async {
    _isInitialized = false;
    userUuid = null;

    features.value = null;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_orient_project_id');
    await prefs.remove('user_orient_user_uuid');

    logUO('Cache cleared', emoji: '🆑');
  }

  /// Initialize the UserOrient SDK. This method must be called before using the SDK.
  static Future<void> initialize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cachedProjectId = prefs.getString('user_orient_project_id');
    final bool hasProjectId = cachedProjectId != null;
    final bool projectChanged = hasProjectId && cachedProjectId != _apiKey;

    if (projectChanged) {
      await clearCache();

      logUO('Project changed, cache cleared...', emoji: '🔄');
    }

    if (!_isInitialized || (userUuid?.isEmpty ?? true) || projectChanged) {
      logUO('Initializing the SDK', emoji: '🚁');

      if (_apiKey == null) {
        throw 'Call `UserOrient.configure()` method before using the SDK';
      }

      // TODO: if user id is cached, continue do that in the background
      userUuid = await UserOrientData.resolveUserUuid(
        projectId: _apiKey!,
        user: user,
      );

      await fetchAndSetFeatures();

      logUO(
        'Initialization completed for project $_apiKey',
        emoji: '✅',
      );

      await prefs.setString('user_orient_project_id', _apiKey!);

      _isInitialized = true;
    } else {
      await fetchAndSetFeatures();
    }
  }

  static Future<void> fetchAndSetFeatures() async {
    final List<dynamic> results = await Future.wait([
      UserOrientData.getFeatures(projectId: _apiKey!, userId: userUuid!),
    ]);

    final List<Feature> features = results[0];
    UserOrient.features.value = features;
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
    required String title,
  }) async {
    logUO('Sending feature request', emoji: '📬');

    await UserOrientData.sendFeatureRequest(
      projectId: _apiKey!,
      userId: userUuid!,
      content: content,
      title: title,
    );

    logUO('Feature request sent', emoji: '🚀');
  }
}
