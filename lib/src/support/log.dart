import 'dart:developer';

import 'package:flutter/foundation.dart';

/// Debug-only log line, tagged so it's easy to filter.
void logUO(
  String message, {
  required String emoji,
}) {
  if (kDebugMode) {
    log('$emoji $message', name: 'U/O');
  }
}
