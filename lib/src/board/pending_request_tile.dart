import 'package:flutter/widgets.dart';

import 'package:userorient_flutter/src/board/label_chip.dart';
import 'package:userorient_flutter/src/board/vote_button.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

/// A request the user sent that's still in review, pinned above the board.
///
/// Laid out like a feature tile so it looks native in any app, but the vote
/// button is a dimmed placeholder: nobody can vote on it yet.
class PendingRequestTile extends StatelessWidget {
  final String request;

  const PendingRequestTile(this.request, {super.key});

  @override
  Widget build(BuildContext context) {
    final Palette palette = context.palette;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VoteButton.placeholder(context),
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
                    color: palette.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: LabelChip(
                    text: UserOrientStrings.of(context).inReview,
                    color: palette.inReview,
                    background: palette.inReviewBackground,
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
