import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class BottomPadding extends StatelessWidget {
  final double defaultHeight;

  const BottomPadding([
    this.defaultHeight = 16.0,
    key,
  ]) : super(key: key);

  static double of(
    BuildContext context, {
    double defaultHeight = 16.0,
  }) {
    final isAndroid = Platform.isAndroid;
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
