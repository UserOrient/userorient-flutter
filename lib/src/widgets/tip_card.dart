import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';

class TipCard extends StatefulWidget {
  const TipCard({super.key});

  @override
  State<TipCard> createState() => _TipCardState();
}

class _TipCardState extends State<TipCard> {
  // bool _isFirstLaunch = false;

  @override
  void initState() {
    super.initState();

    UserOrient.isFirstLaunch().then((value) {
      setState(() {
        // _isFirstLaunch = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: kThemeAnimationDuration,
      curve: Curves.easeInOut,
      child: Container(
        // height: _isFirstLaunch ? 96.0 : 0.0,
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xffF4F4F6),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                color: Color(0xff818391),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Text(
                  'Sizin üçün daha önəmli olan yeniliklərə səs verin ki, onları daha tez tətbiq edək.',
                  // 'Vote for the features that matter most to you so we can implement them faster.',
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 20 / 14,
                    color: Color(0xff585A68),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
