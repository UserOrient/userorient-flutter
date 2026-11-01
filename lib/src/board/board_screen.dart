import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/board/add_request_button.dart';
import 'package:userorient_flutter/src/board/board_list.dart';
import 'package:userorient_flutter/src/board/board_model.dart';
import 'package:userorient_flutter/src/kit/edge_fade.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/sheet_header.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// The roadmap: a pinned title over one scroll, with the add button
/// floating at the bottom.
class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen>
    with SingleTickerProviderStateMixin {
  /// Zero at rest so the title reads at full strength, ramping in over the
  /// first [_fadeRampDistance] of scroll.
  final ValueNotifier<double> _fadeHeight = ValueNotifier<double>(0.0);

  static const double _maxFadeHeight = 56.0;
  static const double _fadeRampDistance = 72.0;
  static const double _bottomFadeHeight = 88.0;

  late final BoardModel _board;
  late final AnimationController _buttonController;
  late final CurvedAnimation _buttonVisibility;
  bool _isButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _board = UserOrientScope.of(context).board;
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0,
    );
    _buttonVisibility = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    // The thanks is for this visit only.
    _board.clearThanks();
    _fadeHeight.dispose();
    _buttonVisibility.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification is! ScrollUpdateNotification) return false;

    final double delta = notification.scrollDelta ?? 0;
    final ScrollMetrics metrics = notification.metrics;

    _fadeHeight.value =
        (metrics.pixels / _fadeRampDistance).clamp(0.0, 1.0) * _maxFadeHeight;

    // Always surface the button at the edges of the list.
    if (metrics.pixels <= 0 || metrics.pixels >= metrics.maxScrollExtent) {
      _showButton(true);
      return false;
    }

    // 2 px dead-zone filters out sub-pixel jitter from inertial scrolling.
    if (delta > 2.0) {
      _showButton(false);
    } else if (delta < -2.0) {
      _showButton(true);
    }

    return false;
  }

  void _showButton(bool visible) {
    if (visible == _isButtonVisible) return;
    _isButtonVisible = visible;
    visible ? _buttonController.forward() : _buttonController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.palette.background,
      body: Column(
        children: [
          SheetHeader(text: UserOrientStrings.of(context).roadmap),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: _handleScroll,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ValueListenableBuilder<double>(
                      valueListenable: _fadeHeight,
                      builder: (context, double fadeHeight, child) {
                        return EdgeFade(
                          topHeight: fadeHeight,
                          bottomHeight: _bottomFadeHeight,
                          child: child!,
                        );
                      },
                      child: MediaQuery.removePadding(
                        context: context,
                        removeBottom: true,
                        child: const BoardList(),
                      ),
                    ),
                  ),
                  AddRequestButton(visibility: _buttonVisibility),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
