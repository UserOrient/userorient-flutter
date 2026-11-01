import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsDe extends UserOrientStrings {
  const StringsDe();

  @override
  String get tip => 'Stimme für die Funktionen, die du bald sehen möchtest.';

  @override
  String get requestHint => 'Beschreibe deine Idee...';

  @override
  String get submit => 'Absenden';

  @override
  String get inReview => 'In Prüfung';

  @override
  String get thanks => 'Danke! Wir sehen es uns bald an.';

  @override
  String get suggestFeature => 'Vorschlag einreichen';

  @override
  String get roadmap => 'Roadmap';

  @override
  String get shipped => 'Implementiert';

  @override
  String get comments => 'Kommentare';

  @override
  String get noCommentsYet => 'Noch keine Kommentare';

  @override
  String get beFirstToComment =>
      'Sei der Erste, der diese Funktion kommentiert';

  @override
  String get guest => 'Anonym';

  @override
  String get commentHint => 'Kommentar schreiben...';

  @override
  String get emailTitle => 'E-Mail-Adresse';

  @override
  String get emailHint => 'Deine E-Mail für Rückmeldungen (optional)';

  @override
  String get send => 'Senden';

  @override
  String get skipAndSend => 'Überspringen und Senden';

  @override
  String get next => 'Weiter';

  @override
  String get invalidEmail => 'Gib eine gültige E-Mail ein';

  @override
  String get emailRequired => 'E-Mail ist erforderlich';

  @override
  String get justNow => 'Gerade eben';

  @override
  String get someTimeAgo => 'Vor einiger Zeit';

  @override
  String get minuteAgo => 'Vor 1 Minute';

  @override
  String minutesAgo(int n) => 'Vor $n Minuten';

  @override
  String get hourAgo => 'Vor 1 Stunde';

  @override
  String hoursAgo(int n) => 'Vor $n Stunden';

  @override
  String get yesterday => 'Gestern';

  @override
  String daysAgo(int n) => 'Vor $n Tagen';

  @override
  String get monthAgo => 'Vor 1 Monat';

  @override
  String monthsAgo(int n) => 'Vor $n Monaten';

  @override
  String get yearAgo => 'Vor 1 Jahr';

  @override
  String yearsAgo(int n) => 'Vor $n Jahren';
}
