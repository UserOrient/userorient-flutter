import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
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
            Container(
              height: 56.0,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xff2A2A2A),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                onPressed: () {
                  UserOrient.openForm(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/add.svg',
                      package: 'userorient_flutter',
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      'Add Feature',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
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
