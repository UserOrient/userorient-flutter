import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

// TODO: add license for not removing Watermark manually
class Watermark extends StatelessWidget {
  const Watermark({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            'assets/uo${context.isDark ? '-dark' : ''}.svg',
            width: 20,
            package: 'userorient_flutter',
          ),
          const SizedBox(width: 6),
          const Text(
            'Powered by UserOrient',
            style: TextStyle(
              fontSize: 14,
              height: 18 / 14,
              color: Color(0xffACAEAF),
            ),
          ),
        ],
      ),
    );
  }
}
