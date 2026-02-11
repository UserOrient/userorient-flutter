import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/project.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/widgets/feature_card.dart';
import 'package:userorient_flutter/src/widgets/watermark.dart';

class BoardList extends StatelessWidget {
  final List<Feature> features;

  const BoardList({super.key, required this.features});

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListView.separated(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              cacheExtent: features.length * 80,
              itemCount: features.length,
              itemBuilder: (context, index) {
                final Feature feature = features[index];

                return FeatureCard(
                  feature,
                  isShimmer: feature.isSkeleton,
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: context.borderColor,
                  height: 1,
                );
              },
            ),
            const SizedBox(height: 32),
            ValueListenableBuilder<Project?>(
              valueListenable: UserOrient.project,
              builder: (context, project, child) {
                if (project?.onPaidPlan == true) {
                  return const SizedBox.shrink();
                }
                return const Watermark();
              },
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}
