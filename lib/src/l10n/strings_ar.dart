import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsAr extends UserOrientStrings {
  const StringsAr();

  @override
  String get tip => 'صوت للميزات التي تريد رؤيتها قريباً.';

  @override
  String get requestHint => 'اصف فكرتك...';

  @override
  String get submit => 'إرسال';

  @override
  String get inReview => 'قيد المراجعة';

  @override
  String get thanks => 'شكرًا! سنراجعه قريبًا.';

  @override
  String get suggestFeature => 'اقتراح ميزة';

  @override
  String get roadmap => 'خريطة الطريق';

  @override
  String get shipped => 'مُنفذ';

  @override
  String get comments => 'التعليقات';

  @override
  String get noCommentsYet => 'لا توجد تعليقات بعد';

  @override
  String get beFirstToComment => 'كن أول من يعلّق على هذه الميزة';

  @override
  String get guest => 'مجهول';

  @override
  String get commentHint => 'أضف تعليقاً...';

  @override
  String get emailTitle => 'البريد الإلكتروني';

  @override
  String get emailHint => 'بريدك الإلكتروني للمتابعة (اختياري)';

  @override
  String get send => 'إرسال';

  @override
  String get skipAndSend => 'تخطي وإرسال';

  @override
  String get next => 'التالي';

  @override
  String get invalidEmail => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get justNow => 'الآن';

  @override
  String get someTimeAgo => 'منذ فترة';

  @override
  String get minuteAgo => 'منذ دقيقة';

  @override
  String minutesAgo(int n) => 'منذ $n دقائق';

  @override
  String get hourAgo => 'منذ ساعة';

  @override
  String hoursAgo(int n) => 'منذ $n ساعات';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(int n) => 'منذ $n أيام';

  @override
  String get monthAgo => 'منذ شهر';

  @override
  String monthsAgo(int n) => 'منذ $n أشهر';

  @override
  String get yearAgo => 'منذ سنة';

  @override
  String yearsAgo(int n) => 'منذ $n سنوات';
}
