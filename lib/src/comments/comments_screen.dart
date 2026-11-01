import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:userorient_flutter/src/board/feature_tile.dart';
import 'package:userorient_flutter/src/comments/comment_composer.dart';
import 'package:userorient_flutter/src/comments/comment_tile.dart';
import 'package:userorient_flutter/src/comments/comments_model.dart';
import 'package:userorient_flutter/src/data/comment.dart';
import 'package:userorient_flutter/src/data/feature.dart';
import 'package:userorient_flutter/src/kit/adaptive_scrollbar.dart';
import 'package:userorient_flutter/src/kit/bottom_inset.dart';
import 'package:userorient_flutter/src/kit/edge_fade.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/sheet_header.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// One feature, its comment thread, and a composer pinned at the bottom.
class CommentsScreen extends StatefulWidget {
  final Feature feature;

  const CommentsScreen({super.key, required this.feature});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late final CommentsModel _comments;

  /// Zero at rest so the feature reads at full strength.
  final ValueNotifier<double> _fadeHeight = ValueNotifier<double>(0.0);

  static const double _maxFadeHeight = 56.0;
  static const double _fadeRampDistance = 72.0;

  @override
  void initState() {
    super.initState();
    final UserOrientScope scope = UserOrientScope.of(context);
    _comments = CommentsModel(
      api: scope.api,
      session: scope.session,
      feature: widget.feature,
    )..load();
  }

  @override
  void dispose() {
    _comments.dispose();
    _fadeHeight.dispose();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      _fadeHeight.value =
          (notification.metrics.pixels / _fadeRampDistance).clamp(0.0, 1.0) *
              _maxFadeHeight;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Palette palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        children: [
          SheetHeader(text: UserOrientStrings.of(context).comments),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: _handleScroll,
              child: ValueListenableBuilder<double>(
                valueListenable: _fadeHeight,
                builder: (context, double fadeHeight, child) {
                  return EdgeFade(
                    topHeight: fadeHeight,
                    bottomHeight: 40.0,
                    child: child!,
                  );
                },
                child: ListenableBuilder(
                  listenable: _comments,
                  builder: (context, _) {
                    return AdaptiveScrollbar(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        children: [
                          FeatureTile.expanded(widget.feature),
                          ..._thread(_comments.comments),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          ColoredBox(
            color: palette.background,
            child: Column(
              children: [
                const SizedBox(height: 16),
                CommentComposer(comments: _comments),
                const BottomInset(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _thread(List<Comment>? comments) {
    if (comments == null) return const [SizedBox(height: 28), _Loading()];
    if (comments.isEmpty) return const [SizedBox(height: 64), _Empty()];

    final Divider divider = Divider(color: context.palette.border, height: 32);

    return [
      const SizedBox(height: 28),
      for (int i = 0; i < comments.length; i++) ...[
        if (i > 0) divider,
        CommentTile(comments[i]),
      ],
    ];
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  static const int _count = 10;

  /// Prime length, so the pattern never repeats over [_count] rows.
  static const List<double> _widths = [0.94, 0.62, 0.81, 0.48, 0.88, 0.7, 0.55];

  @override
  Widget build(BuildContext context) {
    final Divider divider = Divider(color: context.palette.border, height: 32);

    return Column(
      children: [
        for (int i = 0; i < _count; i++) ...[
          if (i > 0) divider,
          CommentSkeleton(secondLine: _widths[i % _widths.length]),
        ],
      ],
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final Palette palette = context.palette;
    final UserOrientStrings strings = UserOrientStrings.of(context);

    return Column(
      children: [
        SvgPicture.asset(
          'assets/comments-empty.svg',
          package: 'userorient_flutter',
          width: 48,
          height: 48,
          colorFilter: ColorFilter.mode(palette.secondaryText, BlendMode.srcIn),
        ),
        const SizedBox(height: 16),
        Text(
          strings.noCommentsYet,
          style: TextStyle(
            fontSize: 18,
            height: 28 / 18,
            color: palette.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          strings.beFirstToComment,
          style: TextStyle(
            fontSize: 14,
            height: 20 / 14,
            color: palette.secondaryText,
          ),
        ),
      ],
    );
  }
}
