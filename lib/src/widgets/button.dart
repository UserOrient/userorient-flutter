import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

enum IconAffinity { leading, trailing }

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final IconAffinity iconAffinity;
  final bool busy;
  final bool disabled;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.iconAffinity = IconAffinity.leading,
    this.busy = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool muted = disabled;

    return GestureDetector(
      onTap: () {
        if (!busy && !disabled) {
          onPressed();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: muted ? context.unvotedContainerColor : context.buttonColor,
          borderRadius: BorderRadius.circular(26),
          // Neutral, and light mode only: a shadow tinted with the object's
          // own colour emits rather than occludes.
          boxShadow: muted || context.isDark
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                  BoxShadow(
                    color: Color(0x1F000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
        ),
        child: busy
            ? Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.buttonTextColor,
                    ),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null && iconAffinity == IconAffinity.leading) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: muted
                          ? context.secondaryTextColor
                          : context.buttonTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (icon != null &&
                      iconAffinity == IconAffinity.trailing) ...[
                    const SizedBox(width: 8),
                    icon!,
                  ],
                ],
              ),
      ),
    );
  }
}
