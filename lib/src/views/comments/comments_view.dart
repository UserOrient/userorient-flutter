import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/models/comment.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/views/comments/comment_item.dart';
import 'package:userorient_flutter/src/views/comments/comment_text_field.dart';
import 'package:userorient_flutter/src/widgets/adaptive_scrollbar.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/sheet_title.dart';
import 'package:userorient_flutter/src/widgets/feature_card.dart';
import 'package:userorient_flutter/src/widgets/progressive_fade.dart';

class CommentsView extends StatefulWidget {
  final Feature feature;

  const CommentsView({
    super.key,
    required this.feature,
  });

  @override
  State<CommentsView> createState() => CommentsViewState();
}

class CommentsViewState extends State<CommentsView> {
  /// Zero at rest so the feature card reads at full strength.
  final ValueNotifier<double> _fadeHeight = ValueNotifier<double>(0.0);

  static const double _maxFadeHeight = 56.0;
  static const double _fadeRampDistance = 72.0;

  static const int _shimmerCount = 10;

  /// Prime length, so the pattern never repeats over [_shimmerCount] rows.
  static const List<double> _shimmerWidths = <double>[
    0.94,
    0.62,
    0.81,
    0.48,
    0.88,
    0.7,
    0.55,
  ];

  @override
  void initState() {
    super.initState();
    UserOrient.getComments(widget.feature);
  }

  @override
  void dispose() {
    _fadeHeight.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      _fadeHeight.value =
          (notification.metrics.pixels / _fadeRampDistance).clamp(0.0, 1.0) *
              _maxFadeHeight;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationsOverrider(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: Column(
          children: [
            SheetTitle(text: L10n.comments),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: _handleScrollNotification,
                      child: ValueListenableBuilder<double>(
                        valueListenable: _fadeHeight,
                        builder: (context, double fadeHeight, child) {
                          return ProgressiveFade(
                            topHeight: fadeHeight,
                            bottomHeight: 40.0,
                            child: child!,
                          );
                        },
                        child: ValueListenableBuilder<List<Comment>?>(
                          valueListenable: UserOrient.comments,
                          builder: (context, value, child) {
                            return AdaptiveScrollbar(
                              child: ListView(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 12, 20, 16),
                                children: [
                                  FeatureCard.full(
                                    widget.feature,
                                  ),
                                  if (value == null) ...[
                                    const SizedBox(height: 28),
                                    for (int i = 0; i < _shimmerCount; i++) ...[
                                      CommentShimmer(
                                        contentFraction: _shimmerWidths[
                                            i % _shimmerWidths.length],
                                      ),
                                      if (i < _shimmerCount - 1)
                                        Divider(
                                          color: context.borderColor,
                                          height: 32,
                                        ),
                                    ],
                                  ] else if (value.isEmpty) ...[
                                    const SizedBox(height: 64),
                                    Center(
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: SvgPicture.asset(
                                          'assets/comments-empty.svg',
                                          package: 'userorient_flutter',
                                          colorFilter: ColorFilter.mode(
                                            context.secondaryTextColor,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: Text(
                                        L10n.noCommentsYet,
                                        style: TextStyle(
                                          fontSize: 18,
                                          height: 28 / 18,
                                          color: context.textColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Center(
                                      child: Text(
                                        L10n.beFirstToComment,
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 20 / 14,
                                          color: context.secondaryTextColor,
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    const SizedBox(height: 28),
                                    for (int i = 0; i < value.length; i++) ...[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommentItem(comment: value[i]),
                                          if (value[i].replies.isNotEmpty)
                                            CommentReply(comment: value[i]),
                                        ],
                                      ),
                                      if (i < value.length - 1)
                                        Divider(
                                          color: context.borderColor,
                                          height: 32,
                                        ),
                                    ],
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: context.backgroundColor,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CommentTextField(
                    featureId: widget.feature.id,
                  ),
                  const BottomPadding(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
