import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/sheet_dismiss.dart';

/// The large title every sheet opens with, with its own dismiss.
class SheetTitle extends StatelessWidget {
  final String text;

  const SheetTitle({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 28,
                height: 34 / 28,
                fontWeight: FontWeight.w800,
                color: context.textColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const _CloseButton(),
        ],
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: SheetDismiss.of(context),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: context.textColor.withValues(alpha: .09),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close_rounded,
          size: 17,
          color: context.textColor.withValues(alpha: .6),
        ),
      ),
    );
  }
}
