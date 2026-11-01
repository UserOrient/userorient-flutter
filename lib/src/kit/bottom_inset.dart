import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Space under the last control: the home indicator's inset on iOS, or
/// [defaultHeight] when there is none.
class BottomInset extends StatelessWidget {
  final double defaultHeight;

  const BottomInset([this.defaultHeight = 16.0, Key? key]) : super(key: key);

  static double of(
    BuildContext context, {
    double defaultHeight = 16.0,
  }) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final bottomPadding =
        isAndroid ? defaultHeight : MediaQuery.of(context).padding.bottom;
    final height = bottomPadding > 0 ? bottomPadding : defaultHeight;

    return height;
  }

  @override
  Widget build(BuildContext context) {
    final height = of(context, defaultHeight: defaultHeight);

    return SizedBox(height: height);
  }
}
