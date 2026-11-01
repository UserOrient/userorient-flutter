import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:userorient_flutter/src/board/label_chip.dart';
import 'package:userorient_flutter/src/board/vote_button.dart';
import 'package:userorient_flutter/src/comments/comments_screen.dart';
import 'package:userorient_flutter/src/data/feature.dart';
import 'package:userorient_flutter/src/data/label.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/skeleton.dart';
import 'package:userorient_flutter/src/kit/tappable.dart';
import 'package:userorient_flutter/src/stage/stage.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// One row on the board: the vote button, then the title, description and
/// labels. Tapping it opens the comments.
class FeatureTile extends StatelessWidget {
  final Feature feature;
  final bool _expanded;

  const FeatureTile(this.feature, {super.key}) : _expanded = false;

  /// Boxed, with the full description and no comment count. Heads the
  /// comments screen.
  const FeatureTile.expanded(this.feature, {super.key}) : _expanded = true;

  @override
  Widget build(BuildContext context) {
    if (feature.isSkeleton) return const _FeatureSkeleton();

    if (_expanded) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: context.palette.border),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: _content(context),
      );
    }

    return Tappable(
      onTap: () {
        Stage.of(context).push(context, CommentsScreen(feature: feature));
      },
      focusRadius: BorderRadius.circular(8),
      child: Padding(
        key: ValueKey(feature.id),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: _content(context),
      ),
    );
  }

  Widget _content(BuildContext context) {
    final Palette palette = context.palette;
    final String language = UserOrientScope.of(context).options.language.name;
    final String description = feature.descriptionForLocale(language);
    final int comments = feature.commentsCount ?? 0;
    final List<Label> labels = [
      for (final Label label in feature.labels ?? const <Label>[])
        if (!label.isShipped) label,
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        VoteButton(feature),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      feature.titleForLocale(language),
                      style: TextStyle(
                        fontSize: 16.0,
                        height: 24 / 16,
                        color: palette.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!_expanded && comments > 0) ...[
                    const SizedBox(width: 12.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: _CommentCount(comments),
                    ),
                  ],
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 2.0),
                Text(
                  description,
                  maxLines: _expanded ? null : 2,
                  overflow: _expanded ? null : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 20 / 14,
                    color: palette.secondaryText,
                  ),
                ),
              ],
              if (labels.isNotEmpty)
                Row(
                  children: [
                    for (final Label label in labels)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                        child: LabelChip.of(context, label),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentCount extends StatelessWidget {
  final int count;

  const _CommentCount(this.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset('assets/comments.svg', package: 'userorient_flutter'),
        const SizedBox(width: 4.0),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 12,
            height: 16 / 12,
            fontFeatures: const [FontFeature.tabularFigures()],
            color: context.palette.secondaryText,
          ),
        ),
      ],
    );
  }
}

/// Mirrors [FeatureTile]'s geometry, so rows don't jump when data lands.
class _FeatureSkeleton extends StatelessWidget {
  const _FeatureSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: 56.0, height: 56.0, radius: 12.0),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 160.0, height: 24.0, radius: 8.0),
                SizedBox(height: 2.0),
                Skeleton(width: 240.0, height: 18.0, radius: 7.0),
                SizedBox(height: 2.0),
                Skeleton(width: 120.0, height: 18.0, radius: 7.0),
              ],
            ),
          ),
          SizedBox(width: 8.0),
        ],
      ),
    );
  }
}
