import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/widgets/feature_card.dart';
import 'package:userorient_flutter/src/widgets/styled_back_button.dart';
import 'package:userorient_flutter/src/widgets/styled_close_button.dart';
import 'package:userorient_flutter/src/widgets/tip_card.dart';
import 'package:userorient_flutter/src/widgets/watermark.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView>
    with SingleTickerProviderStateMixin {
  int _index = 0;
  bool _isFabVisible = true;

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
    _fabAnimation.dispose();
    _fabController.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification) return false;

    final double delta = notification.scrollDelta ?? 0;
    final ScrollMetrics metrics = notification.metrics;

    // Always surface the button at the edges — the user has
    // either reached the end or bounced back to the top.
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
    final bool isMobile = [TargetPlatform.android, TargetPlatform.iOS]
        .contains(defaultTargetPlatform);

    return LocalizationsOverrider(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          title: _Tabs(
            index: _index,
            onIndexChanged: (index) {
              setState(() => _index = index);
              if (!_isFabVisible) {
                _fabController.forward();
                _isFabVisible = true;
              }
            },
          ),
          centerTitle: true,
          leading:
              isMobile ? const StyledBackButton() : const StyledCloseButton(),
        ),
        body: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: Stack(
            children: [
              Column(
                children: [
                  if (_index == 0) const TipCard(),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: UserOrient.features,
                      builder: (context, List<Feature>? features, _) {
                        features ??= List.generate(5, (index) {
                          return Feature.skeleton();
                        });

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
                          child: _List(features: sortedFeatures),
                        );
                      },
                    ),
                  ),
                ],
              ),
              _FloatingCTA(animation: _fabAnimation),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Floating pill CTA — slides out on scroll-down, springs back on scroll-up.
// ---------------------------------------------------------------------------

class _FloatingCTA extends StatelessWidget {
  final Animation<double> animation;

  const _FloatingCTA({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, (1 - animation.value) * 100),
            child: Opacity(
              opacity: animation.value.clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  UserOrient.openForm(context);
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: context.buttonColor,
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: context.buttonColor.withValues(alpha: 0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/add.svg',
                        package: 'userorient_flutter',
                        colorFilter: ColorFilter.mode(
                          context.buttonTextColor,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        L10n.addFeature,
                        style: TextStyle(
                          color: context.buttonTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Feature list
// ---------------------------------------------------------------------------

class _List extends StatelessWidget {
  final List<Feature> features;

  const _List({required this.features});

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
                return const SizedBox(height: 4.0);
              },
            ),
            const SizedBox(height: 32),
            const Watermark(),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tabs
// ---------------------------------------------------------------------------

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
      onTap: () {
        onTap.call();

        HapticFeedback.lightImpact();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 32,
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
            height: 14 / 14,
            fontWeight: FontWeight.w500,
            color: isActive ? context.buttonTextColor : context.textColor,
          ),
        ),
      ),
    );
  }
}
