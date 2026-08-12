import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/button.dart';

/// The success state of the feedback form.
///
/// Deliberately not a route: sending is a state change of the sheet you are
/// already looking at, so this replaces the form's body in place rather than
/// dismissing one sheet and raising another.
class SentContent extends StatelessWidget {
  final VoidCallback onDone;

  const SentContent({super.key, required this.onDone});

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
                      fontSize: 18.0,
                      height: 28 / 18,
                      color: context.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
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
            onPressed: onDone,
            label: L10n.goBack,
          ),
          const BottomPadding(32),
        ],
      ),
    );
  }
}
