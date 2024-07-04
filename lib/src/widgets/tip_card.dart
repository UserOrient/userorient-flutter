import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';

class TipCard extends StatelessWidget {
  const TipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xffF4F4F6),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: Color(0xff818391),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  L10n.tip,
                  style: const TextStyle(
                    fontSize: 14.0,
                    height: 20 / 14,
                    color: Color(0xff585A68),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
