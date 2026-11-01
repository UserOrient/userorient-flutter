import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:userorient_flutter/src/data/feature.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// The square to the left of every feature: an arrow and the vote count,
/// filled with the accent once voted, or a check once shipped.
class VoteButton extends StatelessWidget {
  final Feature feature;

  const VoteButton(this.feature, {super.key});

  /// A dimmed, inert arrow, for requests nobody can vote on yet.
  static Widget placeholder(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: _Box(
        color: context.palette.muted,
        child: const _Arrow(voted: false),
      ),
    );
  }

  static const Color _idleArrow = Color(0xffA9ABB9);

  @override
  Widget build(BuildContext context) {
    final Palette palette = context.palette;

    if (feature.isShipped) {
      return _Box(
        color: palette.shipped,
        child: Transform.scale(
          scale: 56 / 48,
          child: SvgPicture.asset(
            'assets/completed-mark.svg',
            package: 'userorient_flutter',
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        UserOrientScope.of(context).board.toggleVote(feature);

        if (feature.voted) {
          HapticFeedback.lightImpact();
        } else {
          HapticFeedback.mediumImpact();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: _Box(
        color: feature.voted ? palette.accent : palette.muted,
        child: Column(
          children: [
            const SizedBox(height: 5.0),
            _Arrow(voted: feature.voted),
            Text(
              feature.voteCount.toString(),
              style: TextStyle(
                fontSize: 14.0,
                height: 20 / 14,
                color: feature.voted ? palette.onAccent : palette.text,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final Color color;
  final Widget child;

  const _Box({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      height: 56.0,
      width: 56.0,
      margin: const EdgeInsets.only(top: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

class _Arrow extends StatelessWidget {
  final bool voted;

  const _Arrow({required this.voted});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 56 / 48,
      child: SvgPicture.asset(
        voted ? 'assets/upvote-on.svg' : 'assets/upvote-off.svg',
        package: 'userorient_flutter',
        colorFilter: ColorFilter.mode(
          voted ? context.palette.onAccent : VoteButton._idleArrow,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
