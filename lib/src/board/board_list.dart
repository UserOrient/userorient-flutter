import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/board/board_banner.dart';
import 'package:userorient_flutter/src/board/board_model.dart';
import 'package:userorient_flutter/src/board/feature_tile.dart';
import 'package:userorient_flutter/src/board/pending_request_tile.dart';
import 'package:userorient_flutter/src/data/feature.dart';
import 'package:userorient_flutter/src/kit/adaptive_scrollbar.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/watermark.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// The board's one scroll: banner, the user's pending requests, open
/// features, then what already shipped. The title is pinned above it.
class BoardList extends StatelessWidget {
  const BoardList({super.key});

  static const int _skeletonCount = 10;

  @override
  Widget build(BuildContext context) {
    final UserOrientScope scope = UserOrientScope.of(context);
    final BoardModel board = scope.board;

    return ListenableBuilder(
      listenable: board,
      builder: (context, _) {
        final List<Feature> open = board.features == null
            ? List.generate(_skeletonCount, (_) => Feature.skeleton())
            : board.openFeatures.toList();
        final List<Feature> shipped = board.shippedFeatures.toList();

        return AdaptiveScrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const BoardBanner(),
                _PendingRequests(board.pendingRequests),
                _Rows(children: [for (final f in open) FeatureTile(f)]),
                if (shipped.isNotEmpty) ...[
                  _ShippedHeader(count: shipped.length),
                  _Rows(children: [for (final f in shipped) FeatureTile(f)]),
                ],
                if (scope.options.keepWatermark ||
                    board.project?.onPaidPlan != true) ...const [
                  SizedBox(height: 32),
                  Watermark(),
                ],
                // Clears the floating add button.
                const SizedBox(height: 140),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The user's requests still in review. One that arrives while the board
/// is open grows in and glows briefly, so it gets noticed.
class _PendingRequests extends StatefulWidget {
  final List<String> requests;

  const _PendingRequests(this.requests);

  @override
  State<_PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<_PendingRequests> {
  /// What was already there when the board opened. Only newer ones animate.
  late final Set<String> _seen = widget.requests.toSet();

  @override
  Widget build(BuildContext context) {
    final List<Widget> tiles = [
      for (final String request in widget.requests)
        _Arrival(
          key: ValueKey(request),
          animate: !_seen.contains(request),
          child: Column(
            children: [
              PendingRequestTile(request),
              Divider(color: context.palette.border, height: 1),
            ],
          ),
        ),
    ];
    _seen.addAll(widget.requests);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: tiles),
    );
  }
}

/// Grows its child open from the top, then lets a soft glow behind it fade.
class _Arrival extends StatefulWidget {
  final bool animate;
  final Widget child;

  const _Arrival({super.key, required this.animate, required this.child});

  @override
  State<_Arrival> createState() => _ArrivalState();
}

class _ArrivalState extends State<_Arrival> with TickerProviderStateMixin {
  late final AnimationController _grow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final AnimationController _glow = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  late final Animation<double> _size = CurvedAnimation(
    parent: _grow,
    curve: Curves.easeOutCubic,
  );

  /// Peaks as the row finishes opening, then fades out slowly.
  late final Animation<double> _strength = TweenSequence<double>([
    TweenSequenceItem(
      tween:
          Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
      weight: 20,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.0, end: 0.0)
          .chain(CurveTween(curve: Curves.easeInOut)),
      weight: 80,
    ),
  ]).animate(_glow);

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      _grow.forward();
      _glow.forward();
    } else {
      _grow.value = 1.0;
      _glow.value = 1.0;
    }
  }

  @override
  void dispose() {
    _grow.dispose();
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Palette palette = context.palette;

    final Widget glowing = AnimatedBuilder(
      animation: _strength,
      child: widget.child,
      builder: (context, child) {
        final double strength = _strength.value;
        if (strength <= 0.0) return child!;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: -10,
              right: -10,
              top: 4,
              bottom: 5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.inReviewBackground.withValues(
                    alpha: strength,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: palette.inReview.withValues(alpha: .16 * strength),
                      blurRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
            child!,
          ],
        );
      },
    );

    return AnimatedBuilder(
      animation: _size,
      child: glowing,
      builder: (context, child) {
        final double t = _size.value;
        if (t >= 1.0) return child!;

        // Clipped only while opening, so the glow can spill once it's open.
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter,
            heightFactor: t,
            child: Opacity(opacity: t, child: child),
          ),
        );
      },
    );
  }
}

/// Rows separated by hairlines, inset like the rest of the board.
class _Rows extends StatelessWidget {
  final List<Widget> children;

  const _Rows({required this.children});

  @override
  Widget build(BuildContext context) {
    final Color divider = context.palette.border;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(color: divider, height: 1),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _ShippedHeader extends StatelessWidget {
  final int count;

  const _ShippedHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final Palette palette = context.palette;
    TextStyle style(Color color) => TextStyle(
          fontSize: 22,
          height: 28 / 22,
          fontWeight: FontWeight.w800,
          fontFeatures: const [FontFeature.tabularFigures()],
          color: color,
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 4),
      child: Row(
        children: [
          Text(UserOrientStrings.of(context).shipped,
              style: style(palette.text)),
          const SizedBox(width: 8),
          Text(count.toString(), style: style(palette.secondaryText)),
        ],
      ),
    );
  }
}
