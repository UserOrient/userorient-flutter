import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/label.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/navigation.dart';
import 'package:userorient_flutter/src/views/comments/comments_view.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

class FeatureCard extends StatelessWidget {
  final Feature feature;
  final bool isShimmer;
  final bool expanded;

  const FeatureCard(
    this.feature, {
    super.key,
    required this.isShimmer,
  }) : expanded = false;

  const FeatureCard.full(
    this.feature, {
    super.key,
  })  : isShimmer = false,
        expanded = true;

  @override
  Widget build(BuildContext context) {
    final child = isShimmer ? _buildShimmer(context) : _buildWidget(context);

    final content = SizedBox(
      key: ValueKey(feature.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: child,
      ),
    );

    if (expanded) return content;

    return GestureDetector(
      onTap: () {
        Navigation.push(
          context,
          CommentsView(
            feature: feature,
          ),
        );
      },
      behavior: HitTestBehavior.translucent,
      child: content,
    );
  }

  Widget _buildWidget(BuildContext context) {
    final bool isCompleted = feature.labels?.any(
          (label) => label.id == '07d82cf0-51ea-45d5-b274-59edb1b11a20',
        ) ??
        false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (isCompleted) return;

            UserOrient.toggleUpvote(feature);

            if (feature.voted) {
              HapticFeedback.lightImpact();
            } else {
              HapticFeedback.mediumImpact();
            }
          },
          behavior: HitTestBehavior.translucent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: 56.0,
            width: 56.0,
            margin: const EdgeInsets.only(top: 4.0),
            decoration: BoxDecoration(
              color: isCompleted
                  ? context.completedContainerColor
                  : feature.voted
                      ? context.votedContainerColor
                      : context.unvotedContainerColor,
              borderRadius: BorderRadius.circular(12.0),
            ),
            alignment: Alignment.center,
            child: isCompleted
                ? Transform.scale(
                    scale: 56 / 48,
                    child: SvgPicture.asset(
                      'assets/completed-mark.svg',
                      package: 'userorient_flutter',
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 5.0),
                      Transform.scale(
                        scale: 56 / 48,
                        child: SvgPicture.asset(
                          feature.voted
                              ? 'assets/upvote-on.svg'
                              : 'assets/upvote-off.svg',
                          package: 'userorient_flutter',
                          colorFilter: feature.voted
                              ? ColorFilter.mode(
                                  context.buttonTextColor,
                                  BlendMode.srcIn,
                                )
                              : const ColorFilter.mode(
                                  Color(0xffA9ABB9),
                                  BlendMode.srcIn,
                                ),
                        ),
                      ),
                      Text(
                        feature.voteCount.toString(),
                        style: TextStyle(
                          fontSize: 14.0,
                          height: 20 / 14,
                          color: feature.voted
                              ? context.buttonTextColor
                              : context.textColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.titleForLocale(UserOrient.user?.language),
                style: TextStyle(
                  fontSize: 16.0,
                  height: 24 / 16,
                  color: context.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (feature
                  .descriptionForLocale(UserOrient.user?.language)
                  .isNotEmpty) ...[
                const SizedBox(height: 2.0),
                Text(
                  feature.descriptionForLocale(UserOrient.user?.language),
                  maxLines: expanded ? null : 2,
                  overflow: expanded ? null : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 20 / 14,
                    color: context.secondaryTextColor,
                  ),
                ),
              ],
              _LabelRow(
                labels: feature.labels,
              ),
              if (!expanded) ...[
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/comments.svg',
                      package: 'userorient_flutter',
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      feature.commentsCount.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        height: 16 / 12,
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56.0,
          width: 56.0,
          decoration: BoxDecoration(
            color: context.skeletonColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24.0,
                width: 160.0,
                decoration: BoxDecoration(
                  color: context.skeletonColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(height: 2.0),
              Container(
                height: 18.0,
                width: 240.0,
                decoration: BoxDecoration(
                  color: context.skeletonColor,
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
              const SizedBox(height: 2.0),
              Container(
                height: 18.0,
                width: 120.0,
                decoration: BoxDecoration(
                  color: context.skeletonColor,
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }
}

class _LabelRow extends StatelessWidget {
  final List<Label>? labels;

  const _LabelRow({
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    if (labels == null || labels!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        for (final Label label in labels!)
          if (!label.isCompleted)
            Container(
              margin: const EdgeInsets.only(right: 8.0, top: 8.0),
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 4.0,
              ),
              decoration: BoxDecoration(
                color: Color(
                  int.parse('0xff${label.color.replaceAll('#', '')}'),
                ).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                label.name[UserOrient.languageCode] ?? label.name['en'],
                style: TextStyle(
                  fontSize: 12.0,
                  height: 16 / 12,
                  color: Color(
                    int.parse('0xff${label.color.replaceAll('#', '')}'),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
