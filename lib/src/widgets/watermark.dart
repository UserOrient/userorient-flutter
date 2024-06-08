import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          top: 8.0,
          bottom: defaultTargetPlatform == TargetPlatform.android
              ? MediaQuery.of(context).padding.bottom + 16.0
              : MediaQuery.of(context).padding.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color(0xffF4F4F6),
              width: 1.0,
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Powered by',
              style: TextStyle(
                fontSize: 12.0,
                height: 16 / 12,
                color: Color(0xff585A68),
              ),
            ),
            SizedBox(width: 4.0),
            Text(
              'UserOrient',
              style: TextStyle(
                fontSize: 12.0,
                height: 16 / 12,
                color: Color(0xff2F313F),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
