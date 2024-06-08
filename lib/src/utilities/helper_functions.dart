import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void logUO(
  String message, {
  required String emoji,
}) {
  if (kDebugMode) {
    log('$emoji $message', name: 'U/O');
  }
}

Color stringToColor(String? hexStr) {
  if (hexStr == null) {
    return const Color(0xff121212);
  }

  final hexCode = hexStr.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}
