import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

class StyledCloseButton extends StatelessWidget {
  const StyledCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40.0,
        width: 40.0,
        alignment: Alignment.center,
        child: Icon(
          Icons.close_rounded,
          color: context.isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
