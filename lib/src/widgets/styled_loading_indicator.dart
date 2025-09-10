import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

class StyledLoadingIndicator extends StatelessWidget {
  final Color? color;

  const StyledLoadingIndicator({
    super.key,
    this.color,
  }) : _isSmall = false;

  const StyledLoadingIndicator.small({
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
              color: color ?? context.textColor,
            );
          } else {
            return CircularProgressIndicator(
              color: color ?? context.textColor,
              strokeWidth: _isSmall ? 2 : 3,
              strokeCap: StrokeCap.round,
            );
          }
        },
      ),
    );
  }
}
