import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/widgets/button.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

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
      child: Container(
        padding: EdgeInsets.only(
          top: 16.0,
          bottom: defaultTargetPlatform != TargetPlatform.iOS
              ? MediaQuery.of(context).padding.bottom + 12.0
              : MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 120.0,
            ),
          ],
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xffF4F4F6),
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          children: [
            Button(
              onPressed: () {
                UserOrient.openForm(context);
              },
              icon: SvgPicture.asset(
                'assets/add.svg',
                package: 'userorient_flutter',
              ),
              label: L10n.addFeature,
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/uo.svg',
                  package: 'userorient_flutter',
                ),
                const SizedBox(width: 4.0),
                const Text(
                  'Powered by UserOrient',
                  style: TextStyle(
                    fontSize: 12.0,
                    height: 16 / 12,
                    color: Color(0xffACAEAF),
                  ),
                ),
                // const SizedBox(width: 4.0),
                // const Text(
                //   'UserOrient',
                //   style: TextStyle(
                //     fontSize: 12.0,
                //     height: 16 / 12,
                //     color: Color(0xffACAEAF),
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
