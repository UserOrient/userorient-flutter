import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

class Button extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool busy;
  final Color? color;
  final Color? textColor;

  const Button({
    super.key,
    required this.label,
    required this.onPressed,
    this.busy = false,
    this.icon,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!busy) {
          onPressed();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 56.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.center,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: color ?? context.buttonColor,
        ),
        child: busy
            ? Container(
                alignment: Alignment.center,
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? context.buttonTextColor,
                  ),
                  strokeWidth: 3.0,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8.0),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor ?? context.buttonTextColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
