import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/widgets/feature_card.dart';
import 'package:userorient_flutter/src/widgets/styled_close_button.dart';
import 'package:userorient_flutter/src/widgets/tip_card.dart';
import 'package:userorient_flutter/src/widgets/watermark.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  late final ScrollController _scrollController;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            L10n.title,
            style: TextStyle(
              fontSize: 20.0,
              height: 28 / 20,
              fontWeight: FontWeight.bold,
              color: context.textColor,
            ),
          ),
        ),
        centerTitle: false,
        actions: const [
          StyledCloseButton(),
          SizedBox(width: 12.0),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _Tabs(
            index: _index,
            onIndexChanged: (index) {
              setState(() => _index = index);
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: UserOrient.features,
              builder: (context, List<Feature>? features, _) {
                features ??= List.generate(7, (index) {
                  return Feature.skeleton();
                });

                // sort features by status
                final List<Feature> sortedFeatures = features.toList()
                  ..removeWhere((feature) {
                    final bool isCompleted = feature.labels?.any(
                          (label) {
                            return label.id ==
                                '07d82cf0-51ea-45d5-b274-59edb1b11a20';
                          },
                        ) ??
                        false;

                    return _index == 0 ? isCompleted : !isCompleted;
                  });

                return MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: Scrollbar(
                    child: _List(
                      features: sortedFeatures,
                    ),
                  ),
                );
              },
            ),
          ),
          const Watermark(),
        ],
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<Feature> features;

  const _List({
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 16.0,
      ),
      itemCount: features.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const TipCard();
        }

        final Feature feature = features[index - 1];

        return FeatureCard(
          feature,
          isShimmer: feature.isSkeleton,
        );
      },
      separatorBuilder: (context, index) {
        if (index == 0) {
          return const SizedBox(height: 12.0);
        }

        return const SizedBox(height: 4.0);
      },
    );
  }
}

class _Tabs extends StatelessWidget {
  final int index;
  final Function(int) onIndexChanged;

  const _Tabs({
    required this.index,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: context.tabsBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.borderColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _Tab(
            label: L10n.roadmap,
            isActive: index == 0,
            onTap: () => onIndexChanged(0),
          ),
          const SizedBox(width: 2),
          _Tab(
            label: L10n.implemented,
            isActive: index == 1,
            onTap: () => onIndexChanged(1),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final Function() onTap;

  const _Tab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        height: 32,
        duration: const Duration(milliseconds: 100),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isActive ? context.buttonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isActive ? context.buttonTextColor : context.textColor,
          ),
        ),
      ),
    );
  }
}
