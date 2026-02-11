import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/views/board/board_list.dart';
import 'package:userorient_flutter/src/views/board/board_tabs.dart';
import 'package:userorient_flutter/src/views/board/floating_cta.dart';
import 'package:userorient_flutter/src/widgets/styled_back_button.dart';
import 'package:userorient_flutter/src/widgets/styled_close_button.dart';
import 'package:userorient_flutter/src/widgets/tip_card.dart';
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
          title: BoardTabs(
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
                        features ??= List.generate(10, (index) {
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
                          child: BoardList(features: sortedFeatures),
                        );
                      },
                    ),
                  ),
                ],
              ),
              FloatingCTA(animation: _fabAnimation),
            ],
          ),
        ),
      ),
    );
  }
}
