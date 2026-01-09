import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Navigation {
  static final GlobalKey<NavigatorState> _webNavigatorKey =
      GlobalKey<NavigatorState>();

  static Future<T?> push<T>(BuildContext context, Widget child) {
    if ([TargetPlatform.android, TargetPlatform.iOS]
        .contains(defaultTargetPlatform)) {
      return Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => child,
        ),
      );
    }

    // For web, if dialog is already showing, use internal navigation
    if (Navigator.of(context)
            .overlay
            ?.context
            .findAncestorWidgetOfExactType<_WebDialog>() !=
        null) {
      return _webNavigatorKey.currentState!
          .push(MaterialPageRoute(builder: (_) => child));
    }

    // Otherwise show the dialog with internal navigation
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (context) => _WebDialog(child: child),
    );
  }
}

class _WebDialog extends StatefulWidget {
  final Widget child;

  const _WebDialog({required this.child});

  @override
  State<_WebDialog> createState() => _WebDialogState();
}

class _WebDialogState extends State<_WebDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(curve);

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Material(
              elevation: 16,
              borderRadius: BorderRadius.circular(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 480,
                  height: double.infinity,
                  child: Navigator(
                    key: Navigation._webNavigatorKey,
                    onGenerateRoute: (settings) => MaterialPageRoute(
                      builder: (_) => widget.child,
                    ),
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
