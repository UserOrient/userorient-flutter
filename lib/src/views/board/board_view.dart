import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/views/board/board_list.dart';
import 'package:userorient_flutter/src/views/board/floating_cta.dart';
import 'package:userorient_flutter/src/widgets/progressive_fade.dart';
import 'package:userorient_flutter/src/widgets/sheet_title.dart';
import 'package:userorient_flutter/src/widgets/tip_card.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView>
    with SingleTickerProviderStateMixin {
  bool _isFabVisible = true;

  /// Zero at rest so the title reads at full strength, ramping in over the
  /// first [_fadeRampDistance] of scroll.
  final ValueNotifier<double> _fadeHeight = ValueNotifier<double>(0.0);

  static const double _maxFadeHeight = 56.0;
  static const double _fadeRampDistance = 72.0;

  static const double _bottomFadeHeight = 88.0;

  late final AnimationController _fabController;
  late final CurvedAnimation _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _fadeHeight.dispose();
    _fabAnimation.dispose();
    _fabController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification) return false;

    final double delta = notification.scrollDelta ?? 0;
    final ScrollMetrics metrics = notification.metrics;

    _fadeHeight.value =
        (metrics.pixels / _fadeRampDistance).clamp(0.0, 1.0) * _maxFadeHeight;

    // Always surface the button at the edges of the list.
    if (metrics.pixels <= 0 || metrics.pixels >= metrics.maxScrollExtent) {
      if (!_isFabVisible) {
        _fabController.forward();
        _isFabVisible = true;
      }
      return false;
    }

    // 2 px dead-zone filters out sub-pixel jitter from inertial scrolling.
    if (delta > 2.0 && _isFabVisible) {
      _fabController.reverse();
      _isFabVisible = false;
    } else if (delta < -2.0 && !_isFabVisible) {
      _fabController.forward();
      _isFabVisible = true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationsOverrider(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: Column(
          children: [
            SheetTitle(text: L10n.roadmap),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ValueListenableBuilder(
                        valueListenable: UserOrient.features,
                        builder: (context, List<Feature>? features, _) {
                          features ??= List.generate(10, (index) {
                            return Feature.skeleton();
                          });

                          final List<Feature> openFeatures = <Feature>[];
                          final List<Feature> shippedFeatures = <Feature>[];

                          for (final Feature feature in features) {
                            final bool isCompleted =
                                feature.labels?.any((label) {
                                      return label.id ==
                                          '07d82cf0-51ea-45d5-b274-59edb1b11a20';
                                    }) ??
                                    false;

                            (isCompleted ? shippedFeatures : openFeatures)
                                .add(feature);
                          }

                          return ValueListenableBuilder<double>(
                            valueListenable: _fadeHeight,
                            builder: (context, double fadeHeight, child) {
                              return ProgressiveFade(
                                topHeight: fadeHeight,
                                bottomHeight: _bottomFadeHeight,
                                child: child!,
                              );
                            },
                            child: MediaQuery.removePadding(
                              context: context,
                              removeBottom: true,
                              child: BoardList(
                                features: openFeatures,
                                shipped: shippedFeatures,
                                header: const TipCard(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    FloatingCTA(animation: _fabAnimation),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
