import 'package:flutter/material.dart';

class StyledCloseButton extends StatelessWidget {
  const StyledCloseButton({super.key}) : _black = false;

  const StyledCloseButton.black({super.key}) : _black = true;

  final bool _black;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 40.0,
        width: 40.0,
        alignment: Alignment.center,
        child: Icon(
          Icons.close_rounded,
          color: _black ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
