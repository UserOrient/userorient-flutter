import 'package:flutter/material.dart';

/// Dissolves the edges of scrolling content instead of cutting it off.
class ProgressiveFade extends StatelessWidget {
  final Widget child;
  final double topHeight;
  final double bottomHeight;

  const ProgressiveFade({
    super.key,
    required this.child,
    this.topHeight = 0.0,
    this.bottomHeight = 0.0,
  });

  /// Eased ramp — a straight alpha lerp reads as a visible grey wash.
  static const List<double> _ramp = [0.0, 0.08, 0.25, 0.55, 0.85, 1.0];

  @override
  Widget build(BuildContext context) {
    if (topHeight <= 0.0 && bottomHeight <= 0.0) return child;

    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (Rect bounds) {
        final double h = bounds.height;
        final List<double> stops = <double>[];
        final List<Color> colors = <Color>[];

        void add(double stop, double alpha) {
          // Stops must be monotonically increasing.
          final double clamped = stop.clamp(0.0, 1.0);
          if (stops.isNotEmpty && clamped <= stops.last) return;
          stops.add(clamped);
          colors.add(Colors.white.withValues(alpha: alpha));
        }

        if (topHeight > 0.0) {
          final double span = (topHeight / h).clamp(0.0, 0.5);
          for (int i = 0; i < _ramp.length; i++) {
            add(_ramp[i] * span, _ramp[i]);
          }
        } else {
          add(0.0, 1.0);
        }

        if (bottomHeight > 0.0) {
          final double span = (bottomHeight / h).clamp(0.0, 0.5);
          for (int i = _ramp.length - 1; i >= 0; i--) {
            add(1.0 - _ramp[i] * span, _ramp[i]);
          }
        } else {
          add(1.0, 1.0);
        }

        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: stops,
          colors: colors,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
