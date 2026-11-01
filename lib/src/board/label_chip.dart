import 'package:flutter/widgets.dart';

import 'package:userorient_flutter/src/data/label.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// A small tinted tag under a feature, in the color set on the dashboard.
class LabelChip extends StatelessWidget {
  final String text;
  final Color color;
  final Color? background;

  const LabelChip({
    super.key,
    required this.text,
    required this.color,
    this.background,
  });

  factory LabelChip.of(BuildContext context, Label label) {
    final String language = UserOrientScope.of(context).options.language.name;

    return LabelChip(
      text: label.name[language] ?? label.name['en'],
      color: Color(int.parse('0xff${label.color.replaceAll('#', '')}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12.0, height: 16 / 12, color: color),
      ),
    );
  }
}
