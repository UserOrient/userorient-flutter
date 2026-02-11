import 'package:userorient_flutter/src/logic/l10n.dart';

extension DateTimeX on DateTime? {
  String timeAgoWithAllEdgeCases() {
    if (this == null) return L10n.someTimeAgo;
    final diff = DateTime.now().difference(this!);
    return L10n.timeAgo(diff);
  }
}
