import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

class TipCard extends StatefulWidget {
  const TipCard({super.key});

  @override
  State<TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<TipCard> {
  bool _showTip = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _showTip = prefs.getBool('tip_shown') != true;
      });

      if (_showTip) {
        prefs.setBool('tip_shown', true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showTip) {
      return const SizedBox.shrink();
    }

    return AnimatedSize(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: SvgPicture.asset(
                'assets/light-bulb.svg',
                package: 'userorient_flutter',
                width: 14.0,
                height: 14.0,
                colorFilter: ColorFilter.mode(
                  context.textColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(width: 7.0),
            Expanded(
              child: Text(
                L10n.tip,
                style: TextStyle(
                  fontSize: 13.0,
                  height: 18 / 13,
                  color: context.textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
