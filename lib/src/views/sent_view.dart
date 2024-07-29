import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/styled_close_button.dart';

class SentView extends StatelessWidget {
  const SentView({super.key});

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

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
                    child: SvgPicture.network(
                      'https://userorient.com/assets/sent.svg',
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    L10n.sentTitle,
                    style: const TextStyle(
                      fontSize: 20.0,
                      height: 28 / 20,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Text(
                      L10n.sentDescription,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 20 / 14,
                        color: Color(0xffACAEAF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            behavior: HitTestBehavior.translucent,
            child: Container(
              height: 56.0,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                L10n.goBack,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const BottomPadding(),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: const [
        StyledCloseButton.black(),
        SizedBox(width: 16.0),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
