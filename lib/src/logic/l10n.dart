import 'package:userorient_flutter/userorient_flutter.dart';

class L10n {
  static const Map<String, dynamic> _content = {
    'az': {
      'tip':
          'Sizin üçün daha önəmli olan yeniliklərə səs verin ki, onları daha tez tətbiq edək.',
      'form_title': 'Təklif göndər',
      'form_hint': 'Təklifiniz nədir?',
      'submit_form': 'Göndər',
      'sent_title': 'Təklif göndərildi!',
      'sent_description':
          'Təklifinizi nəzərdən keçirəcəyik və əgər bizim yol xəritəmizə uyğun gələrsə, onu siyahıya əlavə edəcəyik. Gözləmədə qalın!',
      'go_back': 'Geri qayıt',
    },
    'en': {
      'tip':
          'Vote on the features that matter most to you so we can implement them faster.',
      'form_title': 'Submit a feature request',
      'form_hint': 'Describe your idea...',
      'submit_form': 'Submit',
      'sent_title': 'Feature request sent!',
      'sent_description':
          'We will review your request and if it fits our roadmap, we will add it to our list of features to build. Stay tuned!',
      'go_back': 'Go back',
    },
  };

  static String get _languageCode => UserOrient.languageCode;

  static String get tip => _content[_languageCode]!['tip'] ?? 'N/A';
  static String get formTitle =>
      _content[_languageCode]!['form_title'] ?? 'N/A';
  static String get formHint => _content[_languageCode]!['form_hint'] ?? 'N/A';
  static String get submitForm =>
      _content[_languageCode]!['submit_form'] ?? 'N/A';
  static String get sentTitle =>
      _content[_languageCode]!['sent_title'] ?? 'N/A';
  static String get sentDescription =>
      _content[_languageCode]!['sent_description'] ?? 'N/A';
  static String get goBack => _content[_languageCode]!['go_back'] ?? 'N/A';
}
