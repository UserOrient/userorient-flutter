import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/kit/palette.dart';

/// Anything the user can press, other than text fields.
class Tappable extends StatefulWidget {
  final VoidCallback? onTap;
  final String? tooltip;
  final BorderRadius focusRadius;
  final Widget child;

  const Tappable({
    super.key,
    required this.onTap,
    this.tooltip,
    this.focusRadius = BorderRadius.zero,
    required this.child,
  });

  @override
  State<Tappable> createState() => _TappableState();
}

class _TappableState extends State<Tappable> {
  bool _showFocus = false;

  bool get _enabled => widget.onTap != null;

  void _setFocusHighlight(bool value) {
    if (value != _showFocus) setState(() => _showFocus = value);
  }

  @override
  Widget build(BuildContext context) {
    Widget result = FocusableActionDetector(
      enabled: _enabled,
      mouseCursor: _enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onShowFocusHighlight: _setFocusHighlight,
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: widget.focusRadius,
            border: _showFocus
                ? Border.all(
                    color: context.palette.text.withValues(alpha: .6),
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  )
                : null,
          ),
          child: widget.child,
        ),
      ),
    );

    final String? tooltip = widget.tooltip;
    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }

    return Semantics(
      button: true,
      enabled: _enabled,
      child: result,
    );
  }
}
