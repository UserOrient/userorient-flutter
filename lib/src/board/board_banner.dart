import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:userorient_flutter/src/board/board_model.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// One line under the title: a voting tip the first time the board opens,
/// and a thanks right after a request is sent.
class BoardBanner extends StatefulWidget {
  const BoardBanner({super.key});

  @override
  State<BoardBanner> createState() => _BoardBannerState();
}

class _BoardBannerState extends State<BoardBanner> {
  static const String _tipShownKey = 'tip_shown';

  bool _showTip = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final bool showTip = prefs.getBool(_tipShownKey) != true;
      if (showTip) prefs.setBool(_tipShownKey, true);
      if (mounted) setState(() => _showTip = showTip);
    });
  }

  @override
  Widget build(BuildContext context) {
    final BoardModel board = UserOrientScope.of(context).board;
    final UserOrientStrings strings = UserOrientStrings.of(context);
    final Palette palette = context.palette;

    return ListenableBuilder(
      listenable: board,
      builder: (context, _) {
        final Widget line;

        if (board.justSent) {
          line = _Line(
            icon: Icon(
              Icons.check_circle_rounded,
              size: 14.0,
              color: palette.thanks,
            ),
            iconTop: 2.0,
            text: strings.thanks,
            color: palette.thanks,
          );
        } else if (_showTip) {
          line = _Line(
            icon: SvgPicture.asset(
              'assets/light-bulb.svg',
              package: 'userorient_flutter',
              width: 14.0,
              height: 14.0,
              colorFilter: ColorFilter.mode(palette.info, BlendMode.srcIn),
            ),
            iconTop: 1.0,
            text: strings.tip,
            color: palette.info,
          );
        } else {
          line = const SizedBox(width: double.infinity);
        }

        return AnimatedSize(
          duration: kThemeAnimationDuration,
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: line,
        );
      },
    );
  }
}

class _Line extends StatelessWidget {
  final Widget icon;
  final double iconTop;
  final String text;
  final Color color;

  const _Line({
    required this.icon,
    required this.iconTop,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: EdgeInsets.only(top: iconTop), child: icon),
          const SizedBox(width: 7.0),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.0,
                height: 18 / 13,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
