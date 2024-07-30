import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

class FeatureCard extends StatelessWidget {
  final Feature feature;
  final bool isShimmer;

  const FeatureCard(
    this.feature, {
    super.key,
    required this.isShimmer,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      child: SizedBox(
        key: ValueKey(feature.id),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xffF2F2F2),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: isShimmer ? _buildShimmer() : _buildWidget(),
        ),
      ),
    );
  }

  Row _buildWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            UserOrient.toggleUpvote(feature);

            if (feature.voted) {
              HapticFeedback.lightImpact();
            } else {
              HapticFeedback.mediumImpact();
            }
          },
          behavior: HitTestBehavior.translucent,
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            height: 56.0,
            width: 56.0,
            decoration: BoxDecoration(
              color: feature.voted
                  ? const Color(0xff2F313F)
                  : const Color(0xffE9EAEE).withOpacity(.75),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.network(
                  // TODO: add upvote icon from assets
                  'https://userorient.com/assets/upvote.svg',
                  // colorFilter: feature.voted ? Colors.white : const Color(0xffA9ABB9),
                  colorFilter: feature.voted
                      ? const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        )
                      : const ColorFilter.mode(
                          Color(0xffA9ABB9),
                          BlendMode.srcIn,
                        ),
                ),
                Text(
                  feature.voteCount.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 24 / 16,
                    color: feature.voted ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                feature.titleForLocale(
                  UserOrient.user?.language,
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                  height: 24 / 16,
                  color: Color(0xff2F313F),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2.0),
              Text(
                feature.descriptionForLocale(
                  UserOrient.user?.language,
                ),
                style: const TextStyle(
                  fontSize: 14.0,
                  height: 20 / 14,
                  color: Color(0xffACAEAF),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }

  Widget _buildShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 56.0,
          width: 56.0,
          decoration: BoxDecoration(
            color: const Color(0xffE9EAEE),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24.0,
                width: 160.0,
                decoration: BoxDecoration(
                  color: const Color(0xffE9EAEE),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              const SizedBox(height: 2.0),
              Container(
                height: 20.0,
                width: 240.0,
                decoration: BoxDecoration(
                  color: const Color(0xffE9EAEE),
                  borderRadius: BorderRadius.circular(7.0),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8.0),
      ],
    );
  }
}
