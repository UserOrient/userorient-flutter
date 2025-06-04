import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/button.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

// TODO: add license for not removing Watermark manually
class Watermark extends StatelessWidget {
  const Watermark(
      {super.key,
      this.buttonColor,
      this.buttonTextColor,
      this.onlyIcon = false});
  final Color? buttonColor;
  final Color? buttonTextColor;
  final bool onlyIcon;

  factory Watermark.icon({Key? key}) {
    return Watermark(
      key: key,
      onlyIcon: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(
          Uri.parse('https://userorient.com'),
          mode: LaunchMode.externalApplication,
        );
      },
      child: onlyIcon
          ? SvgPicture.asset(
              'assets/uo${context.isDark ? '-dark' : ''}.svg',
              package: 'userorient_flutter',
            )
          : Container(
              padding: EdgeInsets.only(
                top: 16.0,
                bottom: defaultTargetPlatform != TargetPlatform.iOS
                    ? MediaQuery.of(context).padding.bottom + 12.0
                    : MediaQuery.of(context).padding.bottom,
              ),
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 0),
                    blurRadius: 120.0,
                  ),
                ],
                color: context.backgroundColor,
                border: Border(
                  top: BorderSide(
                    color: context.borderColor,
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
                      colorFilter: ColorFilter.mode(
                        buttonTextColor ?? context.buttonTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    label: L10n.addFeature,
                    textColor: buttonTextColor,
                    color: buttonColor,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/uo${context.isDark ? '-dark' : ''}.svg',
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
                  if (defaultTargetPlatform == TargetPlatform.iOS)
                    const BottomPadding(32),
                ],
              ),
            ),
    );
  }
}
