import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/button.dart';

class SentView extends StatelessWidget {
  const SentView({super.key, this.buttonColor, this.buttonTextColor});
  final Color? buttonColor;
  final Color? buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: _Body(
        buttonColor: buttonColor,
        buttonTextColor: buttonTextColor,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({this.buttonColor, this.buttonTextColor});
  final Color? buttonColor;
  final Color? buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: SvgPicture.asset(
                      'assets/check.svg',
                      package: 'userorient_flutter',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    L10n.sentTitle,
                    style: TextStyle(
                      fontSize: 20.0,
                      height: 28 / 20,
                      color: context.textColor,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      L10n.sentDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.0,
                        height: 20 / 14,
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Button(
            onPressed: () {
              Navigator.of(context).pop();
            },
            label: L10n.goBack,
            color: buttonColor,
            textColor: buttonTextColor,
          ),
          const BottomPadding(32),
        ],
      ),
    );
  }
}
