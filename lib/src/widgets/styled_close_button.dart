import 'package:flutter/material.dart';

class StyledCloseButton extends StatelessWidget {
  const StyledCloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        height: 40.0,
        width: 40.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.1),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: const Icon(
          Icons.close_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
