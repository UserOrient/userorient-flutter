import 'package:flutter/widgets.dart';

import 'package:userorient_flutter/src/l10n/strings_en.dart';
import 'package:userorient_flutter/src/l10n/strings_ar.dart';
import 'package:userorient_flutter/src/l10n/strings_az.dart';
import 'package:userorient_flutter/src/l10n/strings_de.dart';
import 'package:userorient_flutter/src/l10n/strings_es.dart';
import 'package:userorient_flutter/src/l10n/strings_fr.dart';
import 'package:userorient_flutter/src/l10n/strings_it.dart';
import 'package:userorient_flutter/src/l10n/strings_ru.dart';
import 'package:userorient_flutter/src/l10n/strings_tr.dart';
import 'package:userorient_flutter/src/l10n/strings_uk.dart';
import 'package:userorient_flutter/src/l10n/strings_zh.dart';
import 'package:userorient_flutter/src/support/language.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// Every piece of text the SDK shows. One subclass per [Language], so a
/// missing translation is a compile error rather than a blank label.
abstract class UserOrientStrings {
  const UserOrientStrings();

  /// The strings for the language passed to `UserOrient.configure`.
  static UserOrientStrings of(BuildContext context) {
    return forLanguage(UserOrientScope.of(context).options.language);
  }

  static UserOrientStrings forLanguage(Language language) {
    return switch (language) {
      Language.en => const StringsEn(),
      Language.ar => const StringsAr(),
      Language.az => const StringsAz(),
      Language.de => const StringsDe(),
      Language.es => const StringsEs(),
      Language.fr => const StringsFr(),
      Language.it => const StringsIt(),
      Language.ru => const StringsRu(),
      Language.tr => const StringsTr(),
      Language.uk => const StringsUk(),
      Language.zh => const StringsZh(),
    };
  }

  String get tip;
  String get requestHint;
  String get submit;
  String get inReview;
  String get thanks;
  String get suggestFeature;
  String get roadmap;
  String get shipped;
  String get comments;
  String get noCommentsYet;
  String get beFirstToComment;
  String get guest;
  String get commentHint;
  String get emailTitle;
  String get emailHint;
  String get send;
  String get skipAndSend;
  String get next;
  String get invalidEmail;
  String get emailRequired;
  String get justNow;
  String get someTimeAgo;
  String get minuteAgo;
  String minutesAgo(int n);
  String get hourAgo;
  String hoursAgo(int n);
  String get yesterday;
  String daysAgo(int n);
  String get monthAgo;
  String monthsAgo(int n);
  String get yearAgo;
  String yearsAgo(int n);

  /// "5 minutes ago", "Yesterday" and so on, relative to now.
  String timeAgo(DateTime? time) {
    if (time == null) return someTimeAgo;

    final Duration diff = DateTime.now().difference(time);

    if (diff.inSeconds < 60) return justNow;
    if (diff.inMinutes < 60) {
      return diff.inMinutes == 1 ? minuteAgo : minutesAgo(diff.inMinutes);
    }
    if (diff.inHours < 24) {
      return diff.inHours == 1 ? hourAgo : hoursAgo(diff.inHours);
    }
    if (diff.inDays < 30) {
      return diff.inDays == 1 ? yesterday : daysAgo(diff.inDays);
    }
    if (diff.inDays < 365) {
      final int months = diff.inDays ~/ 30;
      return months == 1 ? monthAgo : monthsAgo(months);
    }

    final int years = diff.inDays ~/ 365;
    return years == 1 ? yearAgo : yearsAgo(years);
  }
}
