import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

/// A request the user sent that's still in review, pinned above the board.
///
/// Laid out like a feature card so it looks native in any app, but the vote
/// box is dimmed and inert: nobody can vote on it yet.
class PendingRequestCard extends StatelessWidget {
  final String request;

  const PendingRequestCard(this.request, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.5,
            child: Container(
              height: 56.0,
              width: 56.0,
              margin: const EdgeInsets.only(top: 4.0),
              decoration: BoxDecoration(
                color: context.unvotedContainerColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              alignment: Alignment.center,
              child: Transform.scale(
                scale: 56 / 48,
                child: SvgPicture.asset(
                  'assets/upvote-off.svg',
                  package: 'userorient_flutter',
                  colorFilter: const ColorFilter.mode(
                    Color(0xffA9ABB9),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  request,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 24 / 16,
                    color: context.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: context.inReviewContainerColor,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Text(
                    L10n.inReview,
                    style: TextStyle(
                      fontSize: 12.0,
                      height: 16 / 12,
                      color: context.inReviewColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
