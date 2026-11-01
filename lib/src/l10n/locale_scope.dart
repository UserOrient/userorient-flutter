import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:userorient_flutter/src/userorient_scope.dart';

/// Puts the SDK's own language under its screens, so text fields, selection
/// toolbars and text direction follow it rather than the app's locale.
class LocaleScope extends StatelessWidget {
  final Widget child;

  const LocaleScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: Locale(UserOrientScope.of(context).options.language.name),
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: child,
    );
  }
}
