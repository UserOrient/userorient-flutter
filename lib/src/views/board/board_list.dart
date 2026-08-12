import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/project.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/widgets/adaptive_scrollbar.dart';
import 'package:userorient_flutter/src/widgets/feature_card.dart';
import 'package:userorient_flutter/src/widgets/watermark.dart';

class BoardList extends StatelessWidget {
  /// Everything still open for voting.
  final List<Feature> features;

  /// Already built. Shown at the tail of the same scroll, not behind a tab.
  final List<Feature> shipped;

  /// Scrolls away with the list. The title is pinned above it by the caller.
  final Widget header;

  const BoardList({
    super.key,
    required this.features,
    this.shipped = const <Feature>[],
    this.header = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveScrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(width: double.infinity, child: header),
            _FeatureList(features: features),
            if (shipped.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 4),
                child: Row(
                  children: [
                    Text(
                      L10n.implemented,
                      style: TextStyle(
                        fontSize: 22,
                        height: 28 / 22,
                        fontWeight: FontWeight.w800,
                        color: context.textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      shipped.length.toString(),
                      style: TextStyle(
                        fontSize: 22,
                        height: 28 / 22,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        fontWeight: FontWeight.w800,
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              _FeatureList(features: shipped),
            ],
            ValueListenableBuilder<Project?>(
              valueListenable: UserOrient.project,
              builder: (context, project, child) {
                if (project?.onPaidPlan == true) {
                  return const SizedBox.shrink();
                }

                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 32),
                    Watermark(),
                  ],
                );
              },
            ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}

class _FeatureList extends StatelessWidget {
  final List<Feature> features;

  const _FeatureList({required this.features});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
    );
  }
}
