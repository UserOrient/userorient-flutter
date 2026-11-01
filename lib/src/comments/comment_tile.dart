import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'package:userorient_flutter/src/data/comment.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/skeleton.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

/// One comment: author, time and text, with the team's reply indented
/// under it when there is one.
class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile(this.comment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CommentBody(comment),
        if (comment.replies.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              padding: const EdgeInsets.only(left: 24),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: context.palette.border, width: 2),
                ),
              ),
              child: _CommentBody(comment.replies.first, fromTeam: true),
            ),
          ),
      ],
    );
  }
}

class _CommentBody extends StatelessWidget {
  final Comment comment;

  /// Marks the author with a check.
  final bool fromTeam;

  const _CommentBody(this.comment, {this.fromTeam = false});

  @override
  Widget build(BuildContext context) {
    final Palette palette = context.palette;
    final UserOrientStrings strings = UserOrientStrings.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              comment.ownerFullName ?? strings.guest,
              style: TextStyle(
                fontSize: 16,
                height: 24 / 16,
                color: palette.secondaryText,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (fromTeam) ...[
              const SizedBox(width: 4),
              SvgPicture.asset(
                'assets/checkmark.svg',
                package: 'userorient_flutter',
                width: 14,
                colorFilter: ColorFilter.mode(palette.accent, BlendMode.srcIn),
              ),
            ],
            if (comment.createdAt != null) ...[
              const Spacer(),
              Text(
                strings.timeAgo(comment.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  height: 16 / 12,
                  color: palette.secondaryText,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          comment.content ?? 'N/A',
          style: TextStyle(fontSize: 16, height: 24 / 16, color: palette.text),
        ),
      ],
    );
  }
}

/// Mirrors [CommentTile]'s geometry, so the thread doesn't jump when the
/// real text lands.
class CommentSkeleton extends StatelessWidget {
  /// How much of the second line to fill, so rows don't look identical.
  final double secondLine;

  const CommentSkeleton({super.key, this.secondLine = 1.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Skeleton(width: 112, height: 16),
            Spacer(),
            Skeleton(width: 40, height: 12),
          ],
        ),
        const SizedBox(height: 12),
        const Skeleton(width: double.infinity, height: 14),
        const SizedBox(height: 8),
        FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: secondLine,
          child: const Skeleton(width: double.infinity, height: 14),
        ),
      ],
    );
  }
}
