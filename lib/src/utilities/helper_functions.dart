import 'dart:developer';

import 'package:flutter/foundation.dart';

void logUO(
  String message, {
  required String emoji,
}) {
  if (kDebugMode) {
    log('$emoji $message', name: 'U/O');
  }
}
