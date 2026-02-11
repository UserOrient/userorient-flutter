import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/models/comment.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/date_time_extensions.dart';

class CommentReply extends StatelessWidget {
  final Comment comment;

  const CommentReply({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: context.borderColor,
              width: 2,
            ),
          ),
        ),
        child: CommentItem.developer(
          comment: comment.replies.first,
        ),
      ),
    );
  }
}

class CommentItem extends StatelessWidget {
  final Comment comment;

  const CommentItem({
    super.key,
    required this.comment,
  }) : _isDeveloper = false;

  const CommentItem.developer({
    super.key,
    required this.comment,
  }) : _isDeveloper = true;

  final bool _isDeveloper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              comment.ownerFullName ?? L10n.guestUser,
              style: TextStyle(
                fontSize: 16,
                height: 24 / 16,
                color: context.secondaryTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_isDeveloper) ...[
              const SizedBox(width: 4),
              SvgPicture.asset(
                'assets/checkmark.svg',
                package: 'userorient_flutter',
                width: 14,
                colorFilter: ColorFilter.mode(
                  context.votedContainerColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
            if (comment.createdAt != null) ...[
              const Spacer(),
              Text(
                comment.createdAt!.timeAgoWithAllEdgeCases(),
                style: TextStyle(
                  fontSize: 12,
                  height: 16 / 12,
                  color: context.secondaryTextColor,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(
          comment.content ?? 'N/A',
          style: TextStyle(
            fontSize: 16,
            height: 24 / 16,
            color: context.textColor,
          ),
        ),
      ],
    );
  }
}
