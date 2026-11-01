import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsIt extends UserOrientStrings {
  const StringsIt();

  @override
  String get tip => 'Vota le funzionalità che vuoi vedere presto.';

  @override
  String get requestHint => 'Descrivi la tua idea...';

  @override
  String get submit => 'Invia';

  @override
  String get inReview => 'In revisione';

  @override
  String get thanks => 'Grazie! Lo esamineremo presto.';

  @override
  String get suggestFeature => 'Aggiungi Funzionalità';

  @override
  String get roadmap => 'Rotta';

  @override
  String get shipped => 'Implementato';

  @override
  String get comments => 'Commenti';

  @override
  String get noCommentsYet => 'Nessun commento ancora';

  @override
  String get beFirstToComment =>
      'Sii il primo a commentare questa funzionalità';

  @override
  String get guest => 'Anonimo';

  @override
  String get commentHint => 'Aggiungi un commento...';

  @override
  String get emailTitle => 'Indirizzo email';

  @override
  String get emailHint => 'La tua email per seguiti (facoltativo)';

  @override
  String get send => 'Invia';

  @override
  String get skipAndSend => 'Salta e Invia';

  @override
  String get next => 'Avanti';

  @override
  String get invalidEmail => 'Inserisci un\'email valida';

  @override
  String get emailRequired => 'L\'email è obbligatoria';

  @override
  String get justNow => 'Proprio ora';

  @override
  String get someTimeAgo => 'Qualche tempo fa';

  @override
  String get minuteAgo => '1 minuto fa';

  @override
  String minutesAgo(int n) => '$n minuti fa';

  @override
  String get hourAgo => '1 ora fa';

  @override
  String hoursAgo(int n) => '$n ore fa';

  @override
  String get yesterday => 'Ieri';

  @override
  String daysAgo(int n) => '$n giorni fa';

  @override
  String get monthAgo => '1 mese fa';

  @override
  String monthsAgo(int n) => '$n mesi fa';

  @override
  String get yearAgo => '1 anno fa';

  @override
  String yearsAgo(int n) => '$n anni fa';

  @override
  String get close => 'Chiudi';

  @override
  String get vote => 'Vota';
}
