import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xff529BDF).withOpacity(.1),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/light-bulb.svg',
              package: 'userorient_flutter',
            ),
            const SizedBox(width: 16.0),
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
