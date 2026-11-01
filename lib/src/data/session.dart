import 'package:shared_preferences/shared_preferences.dart';

import 'package:userorient_flutter/src/data/device_metadata.dart';
import 'package:userorient_flutter/src/data/user.dart';
import 'package:userorient_flutter/src/data/userorient_api.dart';
import 'package:userorient_flutter/src/support/collection_mode.dart';
import 'package:userorient_flutter/src/support/log.dart';

/// Who is using the board on this device, and the id the server knows them by.
///
/// The id is stored on the device, so votes survive restarts. It's resolved
/// once per app run and reused after that.
class Session {
  static const String _projectKey = 'user_orient_project_id';
  static const String _userIdKey = 'user_orient_user_uuid';

  /// Set by `UserOrient.identify`. Null means anonymous.
  User? user;

  /// Sent along with every feature request, when collection is allowed.
  Map<String, dynamic>? metadata;

  Future<String>? _userId;

  /// The server's id for this user, syncing them first if this run hasn't.
  Future<String> userId(UserOrientApi api) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // An id belongs to one project. A new API key starts from scratch.
    final String? cachedProjectId = prefs.getString(_projectKey);
    if (cachedProjectId != null && cachedProjectId != api.projectId) {
      await clear();
      logUO('Project changed, cache cleared...', emoji: '🔄');
    }

    return _userId ??= _resolve(api, prefs).catchError((Object error) {
      // Let the next call try again rather than replaying the failure.
      _userId = null;
      throw error;
    });
  }

  Future<String> _resolve(UserOrientApi api, SharedPreferences prefs) async {
    logUO('Initializing the SDK', emoji: '🚁');

    final String? cachedId = prefs.getString(_userIdKey);
    final String id;
    final String? email;

    if (cachedId != null) {
      logUO('Found cached UUID: $cachedId', emoji: '🔍');

      final SyncedUser synced = await api.syncUser(user, knownId: cachedId);
      id = cachedId;
      email = synced.email;
    } else {
      final SyncedUser synced = await api.syncUser(user);
      await prefs.setString(_userIdKey, synced.id);
      logUO('Acquired a new UUID: ${synced.id}', emoji: '🆕');

      id = synced.id;
      email = synced.email;
    }

    // The server may know an email the app never passed in.
    if (email != null && user?.email == null) {
      adoptEmail(email);
      logUO('Resolved email from server: $email', emoji: '📧');
    }

    await prefs.setString(_projectKey, api.projectId);
    logUO('Initialization completed for project ${api.projectId}', emoji: '✅');

    return id;
  }

  /// Remembers [email] for this user, so the email step is skipped next time.
  void adoptEmail(String email) {
    user = user?.copyWith(email: email) ?? User(email: email);
  }

  /// Gathers device details in the background, unless the app opted out.
  Future<void> collectMetadata(DataCollection collection) async {
    if (collection.metadata == CollectionMode.notCollected) {
      logUO('Metadata collection skipped (notCollected)', emoji: '🕵🏻‍♂️');
      return;
    }

    try {
      metadata = await DeviceMetadata.collect();
      logUO('Meta data ready: $metadata', emoji: '🕵🏻‍♂️');
    } catch (e) {
      logUO('Failed to collect meta data. $e', emoji: '😞');
    }
  }

  /// Forgets the stored id, so the next call syncs from scratch.
  /// The identified [user] stays.
  Future<void> clear() async {
    _userId = null;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_projectKey);
    await prefs.remove(_userIdKey);

    logUO('Cache cleared', emoji: '🆑');
  }
}
