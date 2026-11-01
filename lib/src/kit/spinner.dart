import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/kit/palette.dart';

/// The platform's own activity indicator: Cupertino on iOS, Material elsewhere.
class Spinner extends StatelessWidget {
  final Color? color;

  const Spinner({
    super.key,
    this.color,
  }) : _isSmall = false;

  const Spinner.small({
    super.key,
    this.color,
  }) : _isSmall = true;

  final bool _isSmall;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _isSmall ? 20 : 32,
      height: _isSmall ? 20 : 32,
      alignment: Alignment.center,
      child: Builder(
        builder: (context) {
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            return CupertinoActivityIndicator(
              color: color ?? context.palette.text,
            );
          } else {
            return CircularProgressIndicator(
              color: color ?? context.palette.text,
              strokeWidth: _isSmall ? 2 : 3,
              strokeCap: StrokeCap.round,
            );
          }
        },
      ),
    );
  }
}
