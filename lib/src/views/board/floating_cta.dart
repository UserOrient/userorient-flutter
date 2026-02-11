import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/widgets/button.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

class FloatingCTA extends StatelessWidget {
  final Animation<double> animation;

  const FloatingCTA({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, (1 - animation.value) * 100),
            child: Opacity(
              opacity: animation.value.clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: Button(
                onPressed: () {
                  UserOrient.openForm(context);
                },
                label: L10n.addFeature,
                icon: SvgPicture.asset(
                  'assets/add.svg',
                  package: 'userorient_flutter',
                  colorFilter: ColorFilter.mode(
                    context.buttonTextColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
