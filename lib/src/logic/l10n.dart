import 'package:userorient_flutter/userorient_flutter.dart';

class L10n {
  static bool isSupportedLanguage(String languageCode) {
    return _content.containsKey(languageCode);
  }

  static const Map<String, dynamic> _content = {
    'az': {
      'title': 'Təkliflər',
      'tip': 'Tezliklə görmək istədiklərinizə səs verin.',
      'form_hint': 'Təklifiniz nədir?',
      'submit_form': 'Göndər',
      'sent_title': 'Təklif göndərildi!',
      'sent_description':
          'Təşəkkürlər! Təklifinizi nəzərdən keçirəcəyik və sizi xəbərdar edəcəyik.',
      'go_back': 'Hazır',
      'add_feature': 'Təklif Göndər',
      'roadmap': 'Yol Xəritəsi',
      'implemented': 'Tamamlanmış',
      'formEmpty': 'Təklifinizi daxil edin',
      'comments': 'Rəylər',
      'noCommentsYet': 'Hələ rəy yoxdur',
      'beFirstToComment': 'Bu funksiyaya ilk rəy yazan siz olun',
      'guestUser': 'Qonaq',
      'addComment': 'Rəy yazın...',
      'emailPromptTitle': 'E-poçt ünvanı',
      'emailHint': 'Əlaqə üçün e-poçtunuz (isteğe bağlı)',
      'send': 'Göndər',
      'skipAndSend': 'Keç və Göndər',
      'next': 'Növbəti',
      'invalidEmail': 'Düzgün e-poçt daxil edin',
    },
    'de': {
      'title': 'Vorschläge',
      'tip': 'Stimme für die Funktionen, die du bald sehen möchtest.',
      'form_hint': 'Beschreibe deine Idee...',
      'submit_form': 'Absenden',
      'sent_title': 'Vorschlag gesendet!',
      'sent_description':
          'Danke! Wir prüfen deinen Vorschlag und halten dich auf dem Laufenden.',
      'go_back': 'Fertig',
      'add_feature': 'Vorschlag einreichen',
      'roadmap': 'Roadmap',
      'implemented': 'Implementiert',
      'formEmpty': 'Bitte gib deinen Vorschlag ein',
      'comments': 'Kommentare',
      'noCommentsYet': 'Noch keine Kommentare',
      'beFirstToComment': 'Sei der Erste, der diese Funktion kommentiert',
      'guestUser': 'Gast',
      'addComment': 'Kommentar schreiben...',
      'emailPromptTitle': 'E-Mail-Adresse',
      'emailHint': 'Deine E-Mail für Rückmeldungen (optional)',
      'send': 'Senden',
      'skipAndSend': 'Überspringen und Senden',
      'next': 'Weiter',
      'invalidEmail': 'Gib eine gültige E-Mail ein',
    },
    'en': {
      'title': 'Features',
      'tip': 'Vote the features you want to see soon.',
      'form_hint': 'Describe your idea...',
      'submit_form': 'Submit',
      'sent_title': 'Feature request sent!',
      'sent_description':
          'Thanks! We\'ll review your suggestion and keep you posted.',
      'go_back': 'Done',
      'add_feature': 'Suggest Feature',
      'roadmap': 'Roadmap',
      'implemented': 'Implemented',
      'formEmpty': 'Please enter your suggestion',
      'comments': 'Comments',
      'noCommentsYet': 'No comments yet',
      'beFirstToComment': 'Be the first to comment on this feature',
      'guestUser': 'Guest User',
      'addComment': 'Add a comment...',
      'emailPromptTitle': 'Email address',
      'emailHint': 'Your email for follow-ups (optional)',
      'send': 'Send',
      'skipAndSend': 'Skip and Send',
      'next': 'Next',
      'invalidEmail': 'Enter a valid email',
    },
    'es': {
      'title': 'Sugerencias',
      'tip': 'Vota las funciones que deseas pronto.',
      'form_hint': 'Describe tu idea...',
      'submit_form': 'Enviar',
      'sent_title': '¡Solicitud de sugerencia enviada!',
      'sent_description':
          '¡Gracias! Revisaremos tu sugerencia y te mantendremos informado.',
      'go_back': 'Listo',
      'add_feature': 'Agregar Sugerencia',
      'roadmap': 'Ruta',
      'implemented': 'Implementado',
      'formEmpty': 'Ingresa tu sugerencia',
      'comments': 'Comentarios',
      'noCommentsYet': 'Aún no hay comentarios',
      'beFirstToComment': 'Sé el primero en comentar esta función',
      'guestUser': 'Invitado',
      'addComment': 'Añade un comentario...',
      'emailPromptTitle': 'Correo electrónico',
      'emailHint': 'Tu correo para seguimientos (opcional)',
      'send': 'Enviar',
      'skipAndSend': 'Omitir y Enviar',
      'next': 'Siguiente',
      'invalidEmail': 'Ingresa un correo válido',
    },
    'it': {
      'title': 'Suggerimenti',
      'tip': 'Vota le funzionalità che vuoi vedere presto.',
      'form_hint': 'Descrivi la tua idea...',
      'submit_form': 'Invia',
      'sent_title': 'Richiesta di funzionalità inviata!',
      'sent_description':
          'Grazie! Esamineremo il tuo suggerimento e ti terremo aggiornato.',
      'go_back': 'Fatto',
      'add_feature': 'Aggiungi Funzionalità',
      'roadmap': 'Rotta',
      'implemented': 'Implementato',
      'formEmpty': 'Inserisci il tuo suggerimento',
      'comments': 'Commenti',
      'noCommentsYet': 'Nessun commento ancora',
      'beFirstToComment': 'Sii il primo a commentare questa funzionalità',
      'guestUser': 'Ospite',
      'addComment': 'Aggiungi un commento...',
      'emailPromptTitle': 'Indirizzo email',
      'emailHint': 'La tua email per seguiti (facoltativo)',
      'send': 'Invia',
      'skipAndSend': 'Salta e Invia',
      'next': 'Avanti',
      'invalidEmail': 'Inserisci un\'email valida',
    },
    'tr': {
      'title': 'Öneriler',
      'tip': 'Yakında görmek isteklerinizi oylayın.',
      'form_hint': 'Fikrinizi tanımlayın...',
      'submit_form': 'Gönder',
      'sent_title': 'Öneri isteği gönderildi!',
      'sent_description':
          'Teşekkürler! Önerinizi inceleyecek ve sizi bilgilendireceğiz.',
      'go_back': 'Tamam',
      'add_feature': 'Öneri Gönder',
      'roadmap': 'Yol Haritası',
      'implemented': 'Tamamlanmış',
      'formEmpty': 'Önerinizi girin',
      'comments': 'Yorumlar',
      'noCommentsYet': 'Henüz yorum yok',
      'beFirstToComment': 'Bu özelliğe ilk yorumu siz yapın',
      'guestUser': 'Misafir',
      'addComment': 'Yorum yazın...',
      'emailPromptTitle': 'E-posta adresi',
      'emailHint': 'Takip için e-postanız (isteğe bağlı)',
      'send': 'Gönder',
      'skipAndSend': 'Atla ve Gönder',
      'next': 'İleri',
      'invalidEmail': 'Geçerli bir e-posta girin',
    },
    'ru': {
      'title': 'Предложения',
      'tip': 'Голосуйте за функции, которые хотите увидеть в ближайшее время.',
      'form_hint': 'Опишите вашу идею...',
      'submit_form': 'Отправить',
      'sent_title': 'Запрос отправлен!',
      'sent_description':
          'Спасибо! Мы рассмотрим ваше предложение и будем держать вас в курсе.',
      'go_back': 'Готово',
      'add_feature': 'Предложить идею',
      'roadmap': 'План развития',
      'implemented': 'Выполнено',
      'formEmpty': 'Введите предложение',
      'comments': 'Комментарии',
      'noCommentsYet': 'Комментариев пока нет',
      'beFirstToComment': 'Будьте первым, кто прокомментирует эту функцию',
      'guestUser': 'Гость',
      'addComment': 'Напишите комментарий...',
      'emailPromptTitle': 'Электронная почта',
      'emailHint': 'Ваш email для обратной связи (необязательно)',
      'send': 'Отправить',
      'skipAndSend': 'Пропустить и Отправить',
      'next': 'Далее',
      'invalidEmail': 'Введите корректный email',
    },
    'ar': {
      'title': 'الميزات',
      'tip': 'صوت للميزات التي تريد رؤيتها قريباً.',
      'form_hint': 'اصف فكرتك...',
      'submit_form': 'إرسال',
      'sent_title': 'تم إرسال طلب الميزة!',
      'sent_description':
          'شكراً! سنراجع اقتراحك ونبقيك على اطلاع.',
      'go_back': 'تم',
      'add_feature': 'اقتراح ميزة',
      'roadmap': 'خريطة الطريق',
      'implemented': 'مُنفذ',
      'formEmpty': 'يرجى إدخال اقتراحك',
      'comments': 'التعليقات',
      'noCommentsYet': 'لا توجد تعليقات بعد',
      'beFirstToComment': 'كن أول من يعلّق على هذه الميزة',
      'guestUser': 'ضيف',
      'addComment': 'أضف تعليقاً...',
      'emailPromptTitle': 'البريد الإلكتروني',
      'emailHint': 'بريدك الإلكتروني للمتابعة (اختياري)',
      'send': 'إرسال',
      'skipAndSend': 'تخطي وإرسال',
      'next': 'التالي',
      'invalidEmail': 'أدخل بريداً إلكترونياً صالحاً',
    },
    'uk': {
      'title': 'Пропозиції',
      'tip': 'Голосуйте за функції, які хочете побачити найближчим часом.',
      'form_hint': 'Опишіть свою ідею...',
      'submit_form': 'Надіслати',
      'sent_title': 'Запит на функцію надіслано!',
      'sent_description':
          'Дякуємо! Ми розглянемо вашу пропозицію і триматимемо вас у курсі.',
      'go_back': 'Готово',
      'add_feature': 'Запропонувати функцію',
      'roadmap': 'План розвитку',
      'implemented': 'Реалізовано',
      'formEmpty': 'Будь ласка, введіть пропозицію',
      'comments': 'Коментарі',
      'noCommentsYet': 'Коментарів поки немає',
      'beFirstToComment': 'Будьте першим, хто прокоментує цю функцію',
      'guestUser': 'Гість',
      'addComment': 'Напишіть коментар...',
      'emailPromptTitle': 'Електронна пошта',
      'emailHint': 'Ваш email для зворотного зв\'язку (необов\'язково)',
      'send': 'Надіслати',
      'skipAndSend': 'Пропустити і Надіслати',
      'next': 'Далі',
      'invalidEmail': 'Введіть коректний email',
    },
    'zh': {
      'title': '功能建议',
      'tip': '为你期待的功能投票。',
      'form_hint': '描述你的想法...',
      'submit_form': '提交',
      'sent_title': '功能建议已发送！',
      'sent_description':
          '感谢！我们会审核你的建议并及时通知你。',
      'go_back': '完成',
      'add_feature': '提交建议',
      'roadmap': '路线图',
      'implemented': '已实现',
      'formEmpty': '请输入你的建议',
      'comments': '评论',
      'noCommentsYet': '暂无评论',
      'beFirstToComment': '成为第一个评论此功能的人',
      'guestUser': '访客',
      'addComment': '写下评论...',
      'emailPromptTitle': '电子邮箱',
      'emailHint': '用于跟进的邮箱（选填）',
      'send': '发送',
      'skipAndSend': '跳过并发送',
      'next': '下一步',
      'invalidEmail': '请输入有效的邮箱',
    }
  };

  static String get _languageCode => UserOrient.languageCode;

  static String get tip => _content[_languageCode]!['tip'] ?? 'N/A';
  static String get formHint => _content[_languageCode]!['form_hint'] ?? 'N/A';
  static String get submitForm =>
      _content[_languageCode]!['submit_form'] ?? 'N/A';
  static String get sentTitle =>
      _content[_languageCode]!['sent_title'] ?? 'N/A';
  static String get sentDescription =>
      _content[_languageCode]!['sent_description'] ?? 'N/A';
  static String get goBack => _content[_languageCode]!['go_back'] ?? 'N/A';

  static String get addFeature =>
      _content[_languageCode]!['add_feature'] ?? 'N/A';
  static String get title => _content[_languageCode]!['title'] ?? 'N/A';
  static String get roadmap => _content[_languageCode]!['roadmap'] ?? 'N/A';
  static String get implemented =>
      _content[_languageCode]!['implemented'] ?? 'N/A';
  static String get formEmpty => _content[_languageCode]!['formEmpty'] ?? 'N/A';
  static String get comments => _content[_languageCode]!['comments'] ?? 'N/A';
  static String get noCommentsYet =>
      _content[_languageCode]!['noCommentsYet'] ??
      _content['en']!['noCommentsYet'];
  static String get beFirstToComment =>
      _content[_languageCode]!['beFirstToComment'] ??
      _content['en']!['beFirstToComment'];
  static String get guestUser =>
      _content[_languageCode]!['guestUser'] ?? _content['en']!['guestUser'];
  static String get addComment =>
      _content[_languageCode]!['addComment'] ?? _content['en']!['addComment'];
  static String get emailPromptTitle =>
      _content[_languageCode]!['emailPromptTitle'] ??
      _content['en']!['emailPromptTitle'];
  static String get emailHint =>
      _content[_languageCode]!['emailHint'] ?? _content['en']!['emailHint'];
  static String get send =>
      _content[_languageCode]!['send'] ?? _content['en']!['send'];
  static String get skipAndSend =>
      _content[_languageCode]!['skipAndSend'] ??
      _content['en']!['skipAndSend'];
  static String get next =>
      _content[_languageCode]!['next'] ?? _content['en']!['next'];
  static String get invalidEmail =>
      _content[_languageCode]!['invalidEmail'] ??
      _content['en']!['invalidEmail'];
}
