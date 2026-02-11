import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

class BoardTabs extends StatelessWidget {
  final int index;
  final Function(int) onIndexChanged;

  const BoardTabs({
    super.key,
    required this.index,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: context.tabsBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BoardTab(
            label: L10n.roadmap,
            isActive: index == 0,
            onTap: () => onIndexChanged(0),
          ),
          const SizedBox(width: 2),
          BoardTab(
            label: L10n.implemented,
            isActive: index == 1,
            onTap: () => onIndexChanged(1),
          ),
        ],
      ),
    );
  }
}

class BoardTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final Function() onTap;

  const BoardTab({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();

        HapticFeedback.lightImpact();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 32,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isActive ? context.buttonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            height: 14 / 14,
            fontWeight: FontWeight.w500,
            color: isActive ? context.buttonTextColor : context.textColor,
          ),
        ),
      ),
    );
  }
}
