import 'package:flutter/foundation.dart';

import 'package:userorient_flutter/src/data/comment.dart';
import 'package:userorient_flutter/src/data/feature.dart';
import 'package:userorient_flutter/src/data/session.dart';
import 'package:userorient_flutter/src/data/userorient_api.dart';
import 'package:userorient_flutter/src/support/log.dart';

/// The comment thread under one feature.
class CommentsModel extends ChangeNotifier {
  CommentsModel({
    required this.api,
    required this.session,
    required this.feature,
  });

  final UserOrientApi api;
  final Session session;
  final Feature feature;

  /// Null while loading, newest first.
  List<Comment>? get comments => _comments;
  List<Comment>? _comments;

  bool _disposed = false;

  Future<void> load() async {
    final List<Comment> comments = await api.fetchComments(
      userId: await session.userId(api),
      featureId: feature.id,
    );

    _comments = comments;
    _notify();
  }

  Future<void> add(String content) async {
    await api.addComment(
      userId: await session.userId(api),
      featureId: feature.id,
      content: content,
    );

    logUO('Comment added', emoji: '💬');

    _comments = [
      Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        ownerFullName: session.user?.fullName,
        createdAt: DateTime.now(),
      ),
      ...?_comments,
    ];
    _notify();
  }

  // Requests can land after the screen has closed.
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
