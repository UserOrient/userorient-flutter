import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/tappable.dart';

/// "Powered by UserOrient", hidden on paid plans.
class Watermark extends StatelessWidget {
  const Watermark({super.key});

  @override
  Widget build(BuildContext context) {
    return Tappable(
      focusRadius: BorderRadius.circular(6),
      onTap: () {
        launchUrl(
          Uri.parse('https://userorient.com'),
          mode: LaunchMode.externalApplication,
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/uo${context.palette.isDark ? '-dark' : ''}.svg',
            width: 20,
            package: 'userorient_flutter',
          ),
          const SizedBox(width: 6),
          Text(
            'Powered by UserOrient',
            style: TextStyle(
              fontSize: 14,
              height: 18 / 14,
              color: context.palette.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
