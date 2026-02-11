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
          'Təklifinizi nəzərdən keçirəcəyik və əgər bizim yol xəritəmizə uyğun gələrsə, onu siyahıya əlavə edəcəyik. Gözləmədə qalın!',
      'go_back': 'Geri qayıt',
      'add_feature': 'Təklif Göndər',
      'roadmap': 'Yol Xəritəsi',
      'implemented': 'Tamamlanmış',
      'formEmpty': 'Təklifinizi daxil edin',
      'comments': 'Rəylər',
      'noCommentsYet': 'Hələ rəy yoxdur',
      'beFirstToComment': 'Bu funksiyaya ilk rəy yazan siz olun',
      'guestUser': 'Qonaq',
      'addComment': 'Rəy yazın...',
    },
    'de': {
      'title': 'Vorschläge',
      'tip': 'Stimme für die Funktionen, die du bald sehen möchtest.',
      'form_hint': 'Beschreibe deine Idee...',
      'submit_form': 'Absenden',
      'sent_title': 'Vorschlag gesendet!',
      'sent_description':
          'Wir werden deinen Vorschlag prüfen und ihn, wenn er zu unserer Roadmap passt, in unsere Liste der umzusetzenden Funktionen aufnehmen. Bleib dran!',
      'go_back': 'Zurück',
      'add_feature': 'Vorschlag einreichen',
      'roadmap': 'Roadmap',
      'implemented': 'Implementiert',
      'formEmpty': 'Bitte gib deinen Vorschlag ein',
      'comments': 'Kommentare',
      'noCommentsYet': 'Noch keine Kommentare',
      'beFirstToComment': 'Sei der Erste, der diese Funktion kommentiert',
      'guestUser': 'Gast',
      'addComment': 'Kommentar schreiben...',
    },
    'en': {
      'title': 'Features',
      'tip': 'Vote the features you want to see soon.',
      'form_hint': 'Describe your idea...',
      'submit_form': 'Submit',
      'sent_title': 'Feature request sent!',
      'sent_description':
          'We will review your request and if it fits our roadmap, we will add it to our list of features to build. Stay tuned!',
      'go_back': 'Go back',
      'add_feature': 'Suggest Feature',
      'roadmap': 'Roadmap',
      'implemented': 'Implemented',
      'formEmpty': 'Please enter your suggestion',
      'comments': 'Comments',
      'noCommentsYet': 'No comments yet',
      'beFirstToComment': 'Be the first to comment on this feature',
      'guestUser': 'Guest User',
      'addComment': 'Add a comment...',
    },
    'es': {
      'title': 'Sugerencias',
      'tip': 'Vota las funciones que deseas pronto.',
      'form_hint': 'Describe tu idea...',
      'submit_form': 'Enviar',
      'sent_title': '¡Solicitud de sugerencia enviada!',
      'sent_description':
          'Revisaremos tu solicitud y, si encaja en nuestra hoja de ruta, la añadiremos a nuestra lista de características por desarrollar. ¡Mantente atento!',
      'go_back': 'Volver',
      'add_feature': 'Agregar Sugerencia',
      'roadmap': 'Ruta',
      'implemented': 'Implementado',
      'formEmpty': 'Ingresa tu sugerencia',
      'comments': 'Comentarios',
      'noCommentsYet': 'Aún no hay comentarios',
      'beFirstToComment': 'Sé el primero en comentar esta función',
      'guestUser': 'Invitado',
      'addComment': 'Añade un comentario...',
    },
    'it': {
      'title': 'Suggerimenti',
      'tip': 'Vota le funzionalità che vuoi vedere presto.',
      'form_hint': 'Descrivi la tua idea...',
      'submit_form': 'Invia',
      'sent_title': 'Richiesta di funzionalità inviata!',
      'sent_description':
          'Esamineremo la tua richiesta e, se si adatta alla nostra roadmap, la aggiungeremo alla nostra lista di funzionalità da sviluppare. Resta sintonizzato!',
      'go_back': 'Torna indietro',
      'add_feature': 'Aggiungi Funzionalità',
      'roadmap': 'Rotta',
      'implemented': 'Implementato',
      'formEmpty': 'Inserisci il tuo suggerimento',
      'comments': 'Commenti',
      'noCommentsYet': 'Nessun commento ancora',
      'beFirstToComment': 'Sii il primo a commentare questa funzionalità',
      'guestUser': 'Ospite',
      'addComment': 'Aggiungi un commento...',
    },
    'tr': {
      'title': 'Öneriler',
      'tip': 'Yakında görmek isteklerinizi oylayın.',
      'form_hint': 'Fikrinizi tanımlayın...',
      'submit_form': 'Gönder',
      'sent_title': 'Öneri isteği gönderildi!',
      'sent_description':
          'Talebinizi inceleyeceğiz ve yol haritamıza uyuyorsa, geliştirilecek özellikler listemize ekleyeceğiz. Takipte kalın!',
      'go_back': 'Geri dön',
      'add_feature': 'Öneri Gönder',
      'roadmap': 'Yol Haritası',
      'implemented': 'Tamamlanmış',
      'formEmpty': 'Önerinizi girin',
      'comments': 'Yorumlar',
      'noCommentsYet': 'Henüz yorum yok',
      'beFirstToComment': 'Bu özelliğe ilk yorumu siz yapın',
      'guestUser': 'Misafir',
      'addComment': 'Yorum yazın...',
    },
    'ru': {
      'title': 'Предложения',
      'tip': 'Голосуйте за функции, которые хотите увидеть в ближайшее время.',
      'form_hint': 'Опишите вашу идею...',
      'submit_form': 'Отправить',
      'sent_title': 'Запрос отправлен!',
      'sent_description':
          'Мы рассмотрим ваш запрос и, если он впишется в наш план развития, добавим его в список функций для реализации. Следите за обновлениями!',
      'go_back': 'Назад',
      'add_feature': 'Предложить идею',
      'roadmap': 'План развития',
      'implemented': 'Выполнено',
      'formEmpty': 'Введите предложение',
      'comments': 'Комментарии',
      'noCommentsYet': 'Комментариев пока нет',
      'beFirstToComment': 'Будьте первым, кто прокомментирует эту функцию',
      'guestUser': 'Гость',
      'addComment': 'Напишите комментарий...',
    },
    'ar': {
      'title': 'الميزات',
      'tip': 'صوت للميزات التي تريد رؤيتها قريباً.',
      'form_hint': 'اصف فكرتك...',
      'submit_form': 'إرسال',
      'sent_title': 'تم إرسال طلب الميزة!',
      'sent_description':
          'سنراجع طلبك وإذا كان يتناسب مع خريطة طريقنا، سنضيفه إلى قائمة الميزات المراد تطويرها. ابق على اطلاع!',
      'go_back': 'العودة',
      'add_feature': 'اقتراح ميزة',
      'roadmap': 'خريطة الطريق',
      'implemented': 'مُنفذ',
      'formEmpty': 'يرجى إدخال اقتراحك',
      'comments': 'التعليقات',
      'noCommentsYet': 'لا توجد تعليقات بعد',
      'beFirstToComment': 'كن أول من يعلّق على هذه الميزة',
      'guestUser': 'ضيف',
      'addComment': 'أضف تعليقاً...',
    },
    'uk': {
      'title': 'Пропозиції',
      'tip': 'Голосуйте за функції, які хочете побачити найближчим часом.',
      'form_hint': 'Опишіть свою ідею...',
      'submit_form': 'Надіслати',
      'sent_title': 'Запит на функцію надіслано!',
      'sent_description':
          'Ми розглянемо ваш запит і, якщо він відповідає нашому плану розвитку, додамо його до списку функцій для реалізації. Стежте за оновленнями!',
      'go_back': 'Назад',
      'add_feature': 'Запропонувати функцію',
      'roadmap': 'План розвитку',
      'implemented': 'Реалізовано',
      'formEmpty': 'Будь ласка, введіть пропозицію',
      'comments': 'Коментарі',
      'noCommentsYet': 'Коментарів поки немає',
      'beFirstToComment': 'Будьте першим, хто прокоментує цю функцію',
      'guestUser': 'Гість',
      'addComment': 'Напишіть коментар...',
    },
    'zh': {
      'title': '功能建议',
      'tip': '为你期待的功能投票。',
      'form_hint': '描述你的想法...',
      'submit_form': '提交',
      'sent_title': '功能建议已发送！',
      'sent_description':
          '我们会审核你的建议，如果符合产品规划，会将其加入待开发列表。敬请关注！',
      'go_back': '返回',
      'add_feature': '提交建议',
      'roadmap': '路线图',
      'implemented': '已实现',
      'formEmpty': '请输入你的建议',
      'comments': '评论',
      'noCommentsYet': '暂无评论',
      'beFirstToComment': '成为第一个评论此功能的人',
      'guestUser': '访客',
      'addComment': '写下评论...',
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
}
