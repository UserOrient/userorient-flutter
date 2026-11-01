import 'package:flutter/foundation.dart';

import 'package:userorient_flutter/src/support/collection_mode.dart';
import 'package:userorient_flutter/src/support/language.dart';
import 'package:userorient_flutter/src/support/legacy_theme.dart';

/// Everything passed to `UserOrient.configure`.
@immutable
class UserOrientOptions {
  final String? apiKey;
  final Language language;
  final DataCollection dataCollection;

  /// Shows the watermark even on a paid plan.
  final bool keepWatermark;

  /// Accent colors, plus the deprecated background override.
  // ignore: deprecated_member_use_from_same_package
  final UserOrientTheme? theme;

  const UserOrientOptions({
    this.apiKey,
    this.language = Language.en,
    this.dataCollection = const DataCollection(),
    this.keepWatermark = false,
    this.theme,
  });

  UserOrientOptions copyWith({
    String? apiKey,
    Language? language,
    DataCollection? dataCollection,
    bool? keepWatermark,
    // ignore: deprecated_member_use_from_same_package
    UserOrientTheme? theme,
  }) {
    return UserOrientOptions(
      apiKey: apiKey ?? this.apiKey,
      language: language ?? this.language,
      dataCollection: dataCollection ?? this.dataCollection,
      keepWatermark: keepWatermark ?? this.keepWatermark,
      theme: theme ?? this.theme,
    );
  }
}
