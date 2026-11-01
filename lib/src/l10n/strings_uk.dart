import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsUk extends UserOrientStrings {
  const StringsUk();

  @override
  String get tip =>
      'Голосуйте за функції, які хочете побачити найближчим часом.';

  @override
  String get requestHint => 'Опишіть свою ідею...';

  @override
  String get submit => 'Надіслати';

  @override
  String get inReview => 'На розгляді';

  @override
  String get thanks => 'Дякуємо! Незабаром розглянемо.';

  @override
  String get suggestFeature => 'Запропонувати функцію';

  @override
  String get roadmap => 'План розвитку';

  @override
  String get shipped => 'Реалізовано';

  @override
  String get comments => 'Коментарі';

  @override
  String get noCommentsYet => 'Коментарів поки немає';

  @override
  String get beFirstToComment => 'Будьте першим, хто прокоментує цю функцію';

  @override
  String get guest => 'Анонім';

  @override
  String get commentHint => 'Напишіть коментар...';

  @override
  String get emailTitle => 'Електронна пошта';

  @override
  String get emailHint => 'Ваш email для зворотного зв\'язку (необов\'язково)';

  @override
  String get send => 'Надіслати';

  @override
  String get skipAndSend => 'Пропустити і Надіслати';

  @override
  String get next => 'Далі';

  @override
  String get invalidEmail => 'Введіть коректний email';

  @override
  String get emailRequired => 'Email є обов\'язковим';

  @override
  String get justNow => 'Щойно';

  @override
  String get someTimeAgo => 'Деякий час тому';

  @override
  String get minuteAgo => '1 хвилину тому';

  @override
  String minutesAgo(int n) => '$n хвилин тому';

  @override
  String get hourAgo => '1 годину тому';

  @override
  String hoursAgo(int n) => '$n годин тому';

  @override
  String get yesterday => 'Вчора';

  @override
  String daysAgo(int n) => '$n днів тому';

  @override
  String get monthAgo => '1 місяць тому';

  @override
  String monthsAgo(int n) => '$n місяців тому';

  @override
  String get yearAgo => '1 рік тому';

  @override
  String yearsAgo(int n) => '$n років тому';
}
