import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';

class LocalizationsOverrider extends StatelessWidget {
  final Widget child;

  const LocalizationsOverrider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Localizations(
      locale: Locale(UserOrient.languageCode),
      delegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      child: child,
    );
  }
}
