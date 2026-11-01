import 'package:flutter/foundation.dart';

import 'package:userorient_flutter/src/data/feature.dart';
import 'package:userorient_flutter/src/data/project.dart';
import 'package:userorient_flutter/src/data/session.dart';
import 'package:userorient_flutter/src/data/userorient_api.dart';
import 'package:userorient_flutter/src/support/log.dart';

/// Everything the board shows, and the votes cast on it.
class BoardModel extends ChangeNotifier {
  BoardModel({required this.api, required this.session});

  final UserOrientApi api;
  final Session session;

  /// Null while loading.
  List<Feature>? get features => _features;
  List<Feature>? _features;

  /// Null until loaded, and stays null if loading fails, which keeps the
  /// watermark visible.
  Project? get project => _project;
  Project? _project;

  /// Requests sent this run that are still in review, newest first. Kept in
  /// memory only.
  List<String> get pendingRequests => _pendingRequests;
  List<String> _pendingRequests = const [];

  /// True right after a request is sent, so the board thanks the user once.
  bool get justSent => _justSent;
  bool _justSent = false;

  Iterable<Feature> get openFeatures =>
      (_features ?? const []).where((feature) => !feature.isShipped);

  Iterable<Feature> get shippedFeatures =>
      (_features ?? const []).where((feature) => feature.isShipped);

  Future<void> load() async {
    if (_project == null) _loadProject();

    final String userId = await session.userId(api);
    _features = await api.fetchFeatures(userId: userId);
    notifyListeners();
  }

  Future<void> _loadProject() async {
    try {
      _project = await api.fetchProject();
      notifyListeners();
    } catch (_) {
      // The watermark stays visible by default.
    }
  }

  /// Flips the user's vote right away, then tells the server.
  Future<void> toggleVote(Feature feature) async {
    _features = [
      for (final Feature f in _features ?? const <Feature>[])
        if (f.id == feature.id)
          feature.copyWith(
            voted: !feature.voted,
            voteCount:
                feature.voted ? feature.voteCount - 1 : feature.voteCount + 1,
          )
        else
          f,
    ];
    notifyListeners();

    await api.toggleVote(
      userId: await session.userId(api),
      featureId: feature.id,
    );

    logUO(
      !feature.voted ? 'Upvoted' : 'Removed upvote',
      emoji: !feature.voted ? '👍' : '😶‍🌫️',
    );
  }

  /// Pins a request the user just sent above the board.
  void addPending(String content) {
    _pendingRequests = [content, ..._pendingRequests];
    _justSent = true;
    notifyListeners();
  }

  /// The thanks is for one visit. Called when the board closes.
  void clearThanks() {
    _justSent = false;
  }

  /// Forgets everything, for the next person on this device.
  void reset() {
    _features = null;
    _project = null;
    _pendingRequests = const [];
    _justSent = false;
    notifyListeners();
  }
}
