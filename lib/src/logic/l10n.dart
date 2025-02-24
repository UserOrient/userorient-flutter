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
    },
    'es': {
      'title': 'Sugerencias',
      'tip':
          'Vota por la sugerencia que más te importe para que podamos implementarla más rápido.',
      'form_hint': 'Describe tu idea...',
      'submit_form': 'Enviar',
      'sent_title': '¡Solicitud de sugerencia enviada!',
      'sent_description':
          'Revisaremos tu solicitud y, si encaja en nuestra hoja de ruta, la añadiremos a nuestra lista de características por desarrollar. ¡Mantente atento!',
      'go_back': 'Volver',
      'add_feature': 'Agregar Sugerencia',
      'roadmap': 'Ruta',
      'implemented': 'Implementado',
    },
    'it': {
      'title': 'Suggerimenti',
      'tip':
          'Vota le funzionalità che più ti interessano, così potremo implementarle più velocemente.',
      'form_hint': 'Descrivi la tua idea...',
      'submit_form': 'Invia',
      'sent_title': 'Richiesta di funzionalità inviata!',
      'sent_description':
          'Esamineremo la tua richiesta e, se si adatta alla nostra roadmap, la aggiungeremo alla nostra lista di funzionalità da sviluppare. Resta sintonizzato!',
      'go_back': 'Torna indietro',
      'add_feature': 'Aggiungi Funzionalità',
      'roadmap': 'Rotta',
      'implemented': 'Implementato',
    },
    'tr': {
      'title': 'Öneriler',
      'tip': 'Pek yakında görmek istediğiniz özellikleri oylayın.',
      'form_hint': 'Fikrinizi tanımlayın...',
      'submit_form': 'Gönder',
      'sent_title': 'Öneri isteği gönderildi!',
      'sent_description':
          'Talebinizi inceleyeceğiz ve yol haritamıza uyuyorsa, geliştirilecek özellikler listemize ekleyeceğiz. Takipte kalın!',
      'go_back': 'Geri dön',
      'add_feature': 'Öneri Gönder',
      'roadmap': 'Yol Haritası',
      'implemented': 'Tamamlanmış',
    },
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
}
