import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/widgets/styled_back_button.dart';
import 'package:userorient_flutter/src/widgets/styled_close_button.dart';
import 'package:userorient_flutter/src/widgets/styled_loading_indicator.dart';

class InitializingView extends StatefulWidget {
  final Future<void> Function() initialize;
  final void Function(Object error, StackTrace stackTrace)? onError;
  final Widget child;

  const InitializingView({
    super.key,
    required this.initialize,
    required this.child,
    this.onError,
  });

  @override
  State<InitializingView> createState() => _InitializingViewState();
}

class _InitializingViewState extends State<InitializingView> {
  Object? _error;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _error = null;
      _initialized = false;
    });

    try {
      await widget.initialize();
      if (!mounted) return;
      setState(() => _initialized = true);
    } catch (error, stackTrace) {
      widget.onError?.call(error, stackTrace);
      if (!mounted) return;
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialized) return widget.child;

    final isMobile = <TargetPlatform>{
      TargetPlatform.android,
      TargetPlatform.iOS,
    }.contains(defaultTargetPlatform);

    return LocalizationsOverrider(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading:
              isMobile ? const StyledBackButton() : const StyledCloseButton(),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: _error == null
                ? const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StyledLoadingIndicator(),
                      SizedBox(height: 16),
                      Text('Loading feedback…'),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 40,
                        color: context.secondaryTextColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Feedback is temporarily unavailable.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: context.textColor),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _initialize,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try again'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
