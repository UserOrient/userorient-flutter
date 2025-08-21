import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

class StyledCloseButton extends StatelessWidget {
  const StyledCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = [
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.macOS
    ].contains(defaultTargetPlatform);

    return IconButton(
      onPressed: () {
        if ((kIsWeb || isDesktop) && !Navigator.of(context).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        } else {
          Navigator.of(context).pop();
        }
      },
      icon: Icon(
        Icons.close,
        color: context.textColor,
      ),
    );
  }
}
