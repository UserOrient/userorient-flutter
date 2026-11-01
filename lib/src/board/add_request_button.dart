import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:userorient_flutter/src/kit/button.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';
import 'package:userorient_flutter/src/request/message_step.dart';
import 'package:userorient_flutter/src/stage/stage.dart';

/// Floats over the bottom of the board, and slides away while scrolling down.
class AddRequestButton extends StatelessWidget {
  /// 1 when shown, 0 when tucked away.
  final Animation<double> visibility;

  const AddRequestButton({super.key, required this.visibility});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: visibility,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, (1 - visibility.value) * 100),
            child: Opacity(
              opacity: visibility.value.clamp(0.0, 1.0),
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
                  Stage.of(context).push(context, const MessageStep());
                },
                label: UserOrientStrings.of(context).suggestFeature,
                icon: SvgPicture.asset(
                  'assets/add.svg',
                  package: 'userorient_flutter',
                  colorFilter: ColorFilter.mode(
                    context.palette.onAccent,
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
