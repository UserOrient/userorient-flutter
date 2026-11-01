import 'package:flutter/widgets.dart';

import 'package:userorient_flutter/src/kit/palette.dart';

/// A rounded placeholder bar, shown where text will land once it loads.
class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final double? radius;

  const Skeleton({
    super.key,
    required this.width,
    required this.height,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.palette.skeleton,
        borderRadius: BorderRadius.circular(radius ?? height / 2),
      ),
    );
  }
}
