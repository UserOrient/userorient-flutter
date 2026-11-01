import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsFr extends UserOrientStrings {
  const StringsFr();

  @override
  String get tip =>
      'Votez pour les fonctionnalités que vous souhaitez voir bientôt.';

  @override
  String get requestHint => 'Décrivez votre idée...';

  @override
  String get submit => 'Envoyer';

  @override
  String get inReview => 'En examen';

  @override
  String get thanks => 'Merci ! Nous l\'examinerons bientôt.';

  @override
  String get suggestFeature => 'Suggérer une fonctionnalité';

  @override
  String get roadmap => 'Feuille de route';

  @override
  String get shipped => 'Implémenté';

  @override
  String get comments => 'Commentaires';

  @override
  String get noCommentsYet => 'Pas encore de commentaires';

  @override
  String get beFirstToComment =>
      'Soyez le premier à commenter cette fonctionnalité';

  @override
  String get guest => 'Anonyme';

  @override
  String get commentHint => 'Ajouter un commentaire...';

  @override
  String get emailTitle => 'Adresse e-mail';

  @override
  String get emailHint => 'Votre e-mail pour le suivi (facultatif)';

  @override
  String get send => 'Envoyer';

  @override
  String get skipAndSend => 'Passer et Envoyer';

  @override
  String get next => 'Suivant';

  @override
  String get invalidEmail => 'Entrez un e-mail valide';

  @override
  String get emailRequired => 'L\'e-mail est obligatoire';

  @override
  String get justNow => 'À l\'instant';

  @override
  String get someTimeAgo => 'Il y a quelque temps';

  @override
  String get minuteAgo => 'Il y a 1 minute';

  @override
  String minutesAgo(int n) => 'Il y a $n minutes';

  @override
  String get hourAgo => 'Il y a 1 heure';

  @override
  String hoursAgo(int n) => 'Il y a $n heures';

  @override
  String get yesterday => 'Hier';

  @override
  String daysAgo(int n) => 'Il y a $n jours';

  @override
  String get monthAgo => 'Il y a 1 mois';

  @override
  String monthsAgo(int n) => 'Il y a $n mois';

  @override
  String get yearAgo => 'Il y a 1 an';

  @override
  String yearsAgo(int n) => 'Il y a $n ans';
}
