import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/tappable.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';
import 'package:userorient_flutter/src/stage/stage.dart';

/// The large title every sheet opens with, with its own dismiss.
class SheetHeader extends StatelessWidget {
  final String text;

  const SheetHeader({
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
                color: context.palette.text,
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
    return Tappable(
      onTap: () => Stage.dismiss(context),
      semanticLabel: UserOrientStrings.of(context).close,
      focusRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: context.palette.text.withValues(alpha: .09),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close_rounded,
          size: 17,
          color: context.palette.text.withValues(alpha: .6),
        ),
      ),
    );
  }
}
