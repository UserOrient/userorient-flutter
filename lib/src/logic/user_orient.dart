import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/logic/feedback_meta_data.dart';
import 'package:userorient_flutter/src/models/comment.dart';
import 'package:userorient_flutter/src/utilities/navigation.dart';

import 'package:userorient_flutter/src/models/collection_mode.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/language.dart';
import 'package:userorient_flutter/src/logic/user_orient_data.dart';
import 'package:userorient_flutter/src/models/project.dart';
import 'package:userorient_flutter/src/models/user.dart';
import 'package:userorient_flutter/src/models/theme.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/views/board/board_view.dart';
import 'package:userorient_flutter/src/views/form_view.dart';

/// Main entry point for the UserOrient SDK.
class UserOrient {
  static final ValueNotifier<List<Feature>?> features = ValueNotifier(null);
  static final ValueNotifier<List<Comment>?> comments = ValueNotifier(null);
  static final ValueNotifier<Project?> project = ValueNotifier(null);

  static String? _apiKey;
  static User? user;
  static UserUUID? userUuid;
  static bool _isInitialized = false;
  static String languageCode = 'en';
  static UserOrientTheme? theme;
  static DataCollection dataCollection = const DataCollection();
  static Map<String, dynamic>? _metaData;

  /// Open the UserOrient board view
  static Future<void> openBoard(BuildContext context) {
    _initialize();
    return Navigation.push(context, const BoardView());
  }

  /// Open the UserOrient feature request form
  static Future<void> openForm(BuildContext context) {
    _initialize();
    return Navigation.push(context, const FormView());
  }

  /// Configure the UserOrient SDK. This method must be called before using the SDK.
  ///
  /// [apiKey] is the API Key from the UserOrient dashboard.
  static void configure({
    required String apiKey,
  }) {
    _apiKey = apiKey;
  }

  /// Set the language for the SDK UI.
  static void setLanguage(Language language) {
    UserOrient.languageCode = language.name;
  }

  /// Set data collection preferences for email and metadata.
  static void setDataCollection(DataCollection dataCollection) {
    UserOrient.dataCollection = dataCollection;
  }

  /// Override the default light and/or dark theme colors.
  static void setTheme({
    required UserOrientColors? light,
    required UserOrientColors? dark,
  }) {
    UserOrient.theme = UserOrientTheme(light: light, dark: dark);
    logUO('Custom theme applied', emoji: '🫟');
  }

  /// Identify the current user. Call before opening any views.
  static void setUser({
    String? uniqueIdentifier,
    String? fullName,
    String? email,
    String? phoneNumber,
    bool? isPaying,
    Map<String, dynamic>? extra,
  }) {
    final User user = User(
      uniqueIdentifier: uniqueIdentifier,
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      isPaying: isPaying,
      extra: extra,
    );

    UserOrient.user = user;

    logUO('Set user', emoji: '👤');
  }

  /// Clear all locally cached data and reset the SDK state.
  static Future<void> clearCache() async {
    _isInitialized = false;
    userUuid = null;

    features.value = null;
    project.value = null;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_orient_project_id');
    await prefs.remove('user_orient_user_uuid');

    logUO('Cache cleared', emoji: '🆑');
  }

  static Future<void> _initialize() async {
    _collectMetaData();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? cachedProjectId = prefs.getString('user_orient_project_id');
    final bool hasProjectId = cachedProjectId != null;
    final bool projectChanged = hasProjectId && cachedProjectId != _apiKey;

    if (projectChanged) {
      await clearCache();

      logUO('Project changed, cache cleared...', emoji: '🔄');
    }

    if (!_isInitialized) {
      logUO('Initializing the SDK', emoji: '🚁');

      if (_apiKey == null) {
        throw 'Call `UserOrient.configure()` method before using the SDK';
      }

      _fetchProject();

      // TODO: if user id is cached, continue do that in the background
      final ResolvedUser resolvedUser = await UserOrientData.resolveUserUuid(
        projectId: _apiKey!,
        user: user,
      );

      userUuid = resolvedUser.id;

      // If server knows this user's email but SDK wasn't given one, use it
      if (resolvedUser.email != null && user?.email == null) {
        if (user != null) {
          user = user!.copyWith(email: resolvedUser.email);
        } else {
          user = User(email: resolvedUser.email);
        }
        logUO('Resolved email from server: ${resolvedUser.email}', emoji: '📧');
      }

      await _fetchAndSetFeatures();

      logUO(
        'Initialization completed for project $_apiKey',
        emoji: '✅',
      );

      await prefs.setString('user_orient_project_id', _apiKey!);

      _isInitialized = true;
    } else {
      await _fetchAndSetFeatures();
    }
  }

  static Future<void> _fetchAndSetFeatures() async {
    final List<dynamic> results = await Future.wait([
      UserOrientData.getFeatures(projectId: _apiKey!, userId: userUuid!),
    ]);

    final List<Feature> features = results[0];
    UserOrient.features.value = features;
  }

  static Future<void> _fetchProject() async {
    try {
      final project = await UserOrientData.getProject(projectId: _apiKey!);
      UserOrient.project.value = project;
    } catch (_) {
      // Silently fail — watermark stays visible as default
    }
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
    String? email,
  }) async {
    logUO(
      'Sending feature request: "$content" by ${email ?? '(no email provided)'} with ${_metaData ?? 'uknown'} metadata',
      emoji: '📬',
    );

    final String? resolvedEmail = email ?? user?.email;

    await UserOrientData.sendFeatureRequest(
      projectId: _apiKey!,
      userId: userUuid!,
      content: content,
      email: resolvedEmail,
      metaData: _metaData,
    );

    // Update local user so we skip the email view next time
    if (resolvedEmail != null && user?.email == null) {
      user = user?.copyWith(email: resolvedEmail) ?? User(email: resolvedEmail);
    }

    logUO('Feature request sent. ', emoji: '🚀');
  }

  /// Fetch comments for a feature. Used internally by the SDK.
  static Future<void> getComments(Feature feature) async {
    UserOrient.comments.value = null;

    final List<Comment> comments = await UserOrientData.getComments(
      projectId: _apiKey!,
      userId: userUuid!,
      featureId: feature.id,
    );

    UserOrient.comments.value = comments;
  }

  /// Post a comment on a feature. Used internally by the SDK.
  static Future<void> addComment({
    required String content,
    required String featureId,
  }) async {
    await UserOrientData.addComment(
      projectId: _apiKey!,
      userId: userUuid!,
      featureId: featureId,
      content: content,
    );

    logUO('Comment added', emoji: '💬');

    UserOrient.comments.value = [
      Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        ownerFullName: user?.fullName,
        createdAt: DateTime.now(),
      ),
      ...UserOrient.comments.value!,
    ];
  }

  // Collects meta data to be sent with each feature request
  static Future<void> _collectMetaData() async {
    if (dataCollection.metadata == CollectionMode.notCollected) {
      logUO('Metadata collection skipped (notCollected)', emoji: '🕵🏻‍♂️');
      return;
    }

    try {
      _metaData = await FeedbackMetaData.collect();

      logUO('Meta data ready: $_metaData', emoji: '🕵🏻‍♂️');
    } catch (e) {
      logUO('Failed to collect meta data. $e', emoji: '😞');
    }
  }
}
