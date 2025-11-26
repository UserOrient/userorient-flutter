import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';

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
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
        decoration: BoxDecoration(
          color: const Color(0xff529BDF).withValues(alpha: .1),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/light-bulb.svg',
              package: 'userorient_flutter',
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Text(
                L10n.tip,
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 20 / 14,
                  color: Color(0xff529BDF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
