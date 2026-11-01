import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsRu extends UserOrientStrings {
  const StringsRu();

  @override
  String get tip =>
      'Голосуйте за функции, которые хотите увидеть в ближайшее время.';

  @override
  String get requestHint => 'Опишите вашу идею...';

  @override
  String get submit => 'Отправить';

  @override
  String get inReview => 'На рассмотрении';

  @override
  String get thanks => 'Спасибо! Скоро рассмотрим.';

  @override
  String get suggestFeature => 'Предложить идею';

  @override
  String get roadmap => 'План развития';

  @override
  String get shipped => 'Выполнено';

  @override
  String get comments => 'Комментарии';

  @override
  String get noCommentsYet => 'Комментариев пока нет';

  @override
  String get beFirstToComment =>
      'Будьте первым, кто прокомментирует эту функцию';

  @override
  String get guest => 'Аноним';

  @override
  String get commentHint => 'Напишите комментарий...';

  @override
  String get emailTitle => 'Электронная почта';

  @override
  String get emailHint => 'Ваш email для обратной связи (необязательно)';

  @override
  String get send => 'Отправить';

  @override
  String get skipAndSend => 'Пропустить и Отправить';

  @override
  String get next => 'Далее';

  @override
  String get invalidEmail => 'Введите корректный email';

  @override
  String get emailRequired => 'Email обязателен';

  @override
  String get justNow => 'Только что';

  @override
  String get someTimeAgo => 'Некоторое время назад';

  @override
  String get minuteAgo => '1 минуту назад';

  @override
  String minutesAgo(int n) => '$n минут назад';

  @override
  String get hourAgo => '1 час назад';

  @override
  String hoursAgo(int n) => '$n часов назад';

  @override
  String get yesterday => 'Вчера';

  @override
  String daysAgo(int n) => '$n дней назад';

  @override
  String get monthAgo => '1 месяц назад';

  @override
  String monthsAgo(int n) => '$n месяцев назад';

  @override
  String get yearAgo => '1 год назад';

  @override
  String yearsAgo(int n) => '$n лет назад';

  @override
  String get close => 'Закрыть';

  @override
  String get vote => 'Голосовать';
}
