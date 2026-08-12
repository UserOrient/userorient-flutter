import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A scrollbar only where the platform does not already draw one.
class AdaptiveScrollbar extends StatelessWidget {
  final Widget child;

  const AdaptiveScrollbar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    const List<TargetPlatform> touch = <TargetPlatform>[
      TargetPlatform.android,
      TargetPlatform.iOS,
    ];

    if (!touch.contains(defaultTargetPlatform)) return child;

    return Scrollbar(child: child);
  }
}
