import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsTr extends UserOrientStrings {
  const StringsTr();

  @override
  String get tip => 'Yakında görmek isteklerinizi oylayın.';

  @override
  String get requestHint => 'Fikrinizi tanımlayın...';

  @override
  String get submit => 'Gönder';

  @override
  String get inReview => 'İnceleniyor';

  @override
  String get thanks => 'Teşekkürler! Yakında inceleyeceğiz.';

  @override
  String get suggestFeature => 'Öneri Gönder';

  @override
  String get roadmap => 'Yol Haritası';

  @override
  String get shipped => 'Tamamlanmış';

  @override
  String get comments => 'Yorumlar';

  @override
  String get noCommentsYet => 'Henüz yorum yok';

  @override
  String get beFirstToComment => 'Bu özelliğe ilk yorumu siz yapın';

  @override
  String get guest => 'Anonim';

  @override
  String get commentHint => 'Yorum yazın...';

  @override
  String get emailTitle => 'E-posta adresi';

  @override
  String get emailHint => 'Takip için e-postanız (isteğe bağlı)';

  @override
  String get send => 'Gönder';

  @override
  String get skipAndSend => 'Atla ve Gönder';

  @override
  String get next => 'İleri';

  @override
  String get invalidEmail => 'Geçerli bir e-posta girin';

  @override
  String get emailRequired => 'E-posta gereklidir';

  @override
  String get justNow => 'Az önce';

  @override
  String get someTimeAgo => 'Bir süre önce';

  @override
  String get minuteAgo => '1 dakika önce';

  @override
  String minutesAgo(int n) => '$n dakika önce';

  @override
  String get hourAgo => '1 saat önce';

  @override
  String hoursAgo(int n) => '$n saat önce';

  @override
  String get yesterday => 'Dün';

  @override
  String daysAgo(int n) => '$n gün önce';

  @override
  String get monthAgo => '1 ay önce';

  @override
  String monthsAgo(int n) => '$n ay önce';

  @override
  String get yearAgo => '1 yıl önce';

  @override
  String yearsAgo(int n) => '$n yıl önce';

  @override
  String get close => 'Kapat';

  @override
  String get vote => 'Oy ver';
}
