import 'package:flutter/widgets.dart';

import 'package:userorient_flutter/src/board/board_model.dart';
import 'package:userorient_flutter/src/board/board_screen.dart';
import 'package:userorient_flutter/src/data/session.dart';
import 'package:userorient_flutter/src/data/user.dart';
import 'package:userorient_flutter/src/data/userorient_api.dart';
import 'package:userorient_flutter/src/request/message_step.dart';
import 'package:userorient_flutter/src/stage/stage.dart';
import 'package:userorient_flutter/src/support/collection_mode.dart';
import 'package:userorient_flutter/src/support/language.dart';
import 'package:userorient_flutter/src/support/legacy_theme.dart';
import 'package:userorient_flutter/src/support/log.dart';
import 'package:userorient_flutter/src/userorient_options.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// Main entry point for the UserOrient SDK.
class UserOrient {
  const UserOrient._();

  static UserOrientOptions _options = const UserOrientOptions();
  static final Session _session = Session();

  // Built on first open, and again whenever the API key changes.
  static UserOrientApi? _api;
  static BoardModel? _board;

  /// Open the UserOrient board.
  ///
  /// This is the only entry point. The form for suggesting a feature is
  /// reached from the board itself, so people see what already exists — and
  /// upvote it — before filing a duplicate.
  static Future<void> openBoard(BuildContext context) {
    return _open(context, const BoardScreen());
  }

  /// Open the feature request form directly.
  @Deprecated(
    'Use openBoard() — routing people through the board cuts duplicate '
    'requests. Will be removed in 4.0.0.',
  )
  static Future<void> openForm(BuildContext context) {
    return _open(context, const MessageStep());
  }

  /// Configure the UserOrient SDK. Call this once, before opening the board.
  ///
  /// [apiKey] is the API Key from the UserOrient dashboard.
  ///
  /// [accentColor] tints the primary button and the voted state. Text on top
  /// of it is derived automatically, so it stays legible whatever you pass.
  /// [darkAccentColor] is used when the host app is in dark mode; it falls
  /// back to [accentColor].
  ///
  /// [keepWatermark] shows "Powered by UserOrient" even on a paid plan.
  /// Free plans always show it.
  ///
  /// The board owns its own surface — background, dividers and skeletons are
  /// not configurable, so they can never fall out of contrast with each other.
  static void configure({
    required String apiKey,
    Color? accentColor,
    Color? darkAccentColor,
    Language? language,
    CollectionMode? collectEmail,
    CollectionMode? collectMetadata,
    bool? keepWatermark,
  }) {
    _options = _options.copyWith(
      apiKey: apiKey,
      language: language,
      keepWatermark: keepWatermark,
      dataCollection: DataCollection(
        email: collectEmail ?? _options.dataCollection.email,
        metadata: collectMetadata ?? _options.dataCollection.metadata,
      ),
    );

    if (accentColor != null || darkAccentColor != null) {
      _options = _options.copyWith(
        // ignore: deprecated_member_use_from_same_package
        theme: UserOrientTheme(
          // ignore: deprecated_member_use_from_same_package
          light: UserOrientColors(accentColor: accentColor),
          // ignore: deprecated_member_use_from_same_package
          dark: UserOrientColors(accentColor: darkAccentColor ?? accentColor),
        ),
      );

      logUO('Accent color applied', emoji: '🫟');
    }
  }

  /// Identify the current user. Call before opening the board.
  ///
  /// Every field is optional — with none of them, the user is anonymous but
  /// still gets a stable identity so their votes persist.
  static void identify({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    bool? isPaying,
    Map<String, dynamic>? extra,
  }) {
    _session.user = User(
      uniqueIdentifier: id,
      fullName: name,
      email: email,
      phoneNumber: phoneNumber,
      isPaying: isPaying,
      extra: extra,
    );

    logUO('Identified user', emoji: '👤');
  }

  /// Forget the current user and drop everything cached about them.
  ///
  /// Call this when someone signs out of your app, so the next person does not
  /// inherit their votes.
  static Future<void> logout() async {
    _session.user = null;

    await _clearCache();

    logUO('Logged out', emoji: '👋');
  }

  @Deprecated(
    'Use configure(language: ...) instead. Will be removed in 4.0.0.',
  )
  static void setLanguage(Language language) {
    _options = _options.copyWith(language: language);
  }

  @Deprecated(
    'Use configure(collectEmail: ..., collectMetadata: ...) instead. '
    'Will be removed in 4.0.0.',
  )
  static void setDataCollection(DataCollection dataCollection) {
    _options = _options.copyWith(dataCollection: dataCollection);
  }

  @Deprecated(
    'Use configure(accentColor: ..., darkAccentColor: ...) instead. '
    'Background colors are no longer configurable. '
    'Will be removed in 4.0.0.',
  )
  static void setTheme({
    required UserOrientColors? light,
    required UserOrientColors? dark,
  }) {
    _options = _options.copyWith(
      theme: UserOrientTheme(light: light, dark: dark),
    );
    logUO('Custom theme applied', emoji: '🫟');
  }

  @Deprecated('Use identify() instead. Will be removed in 4.0.0.')
  static void setUser({
    String? uniqueIdentifier,
    String? fullName,
    String? email,
    String? phoneNumber,
    bool? isPaying,
    Map<String, dynamic>? extra,
  }) {
    identify(
      id: uniqueIdentifier,
      name: fullName,
      email: email,
      phoneNumber: phoneNumber,
      isPaying: isPaying,
      extra: extra,
    );
  }

  /// Clear all locally cached data and reset the SDK state.
  @Deprecated(
    'Use logout() — it also forgets the identified user. '
    'Will be removed in 4.0.0.',
  )
  static Future<void> clearCache() => _clearCache();

  static Future<void> _clearCache() async {
    _board?.reset();
    await _session.clear();
  }

  static Future<void> _open(BuildContext context, Widget screen) {
    final UserOrientScope scope = _scope(screen);

    _session.collectMetadata(_options.dataCollection);
    scope.board.load();

    return scope.stage.open(context, scope);
  }

  static UserOrientScope _scope(Widget screen) {
    final String? apiKey = _options.apiKey;
    if (apiKey == null) {
      throw StateError(
        'Call `UserOrient.configure()` method before using the SDK',
      );
    }

    if (_api?.projectId != apiKey) {
      _api = UserOrientApi(projectId: apiKey);
      _board = BoardModel(api: _api!, session: _session);
    }

    return UserOrientScope(
      options: _options,
      api: _api!,
      session: _session,
      board: _board!,
      stage: Stage.adaptive(),
      child: screen,
    );
  }
}
