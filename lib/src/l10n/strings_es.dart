import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

class StringsEs extends UserOrientStrings {
  const StringsEs();

  @override
  String get tip => 'Vota las funciones que deseas pronto.';

  @override
  String get requestHint => 'Describe tu idea...';

  @override
  String get submit => 'Enviar';

  @override
  String get inReview => 'En revisión';

  @override
  String get thanks => '¡Gracias! Lo revisaremos pronto.';

  @override
  String get suggestFeature => 'Agregar Sugerencia';

  @override
  String get roadmap => 'Ruta';

  @override
  String get shipped => 'Implementado';

  @override
  String get comments => 'Comentarios';

  @override
  String get noCommentsYet => 'Aún no hay comentarios';

  @override
  String get beFirstToComment => 'Sé el primero en comentar esta función';

  @override
  String get guest => 'Anónimo';

  @override
  String get commentHint => 'Añade un comentario...';

  @override
  String get emailTitle => 'Correo electrónico';

  @override
  String get emailHint => 'Tu correo para seguimientos (opcional)';

  @override
  String get send => 'Enviar';

  @override
  String get skipAndSend => 'Omitir y Enviar';

  @override
  String get next => 'Siguiente';

  @override
  String get invalidEmail => 'Ingresa un correo válido';

  @override
  String get emailRequired => 'El correo es obligatorio';

  @override
  String get justNow => 'Justo ahora';

  @override
  String get someTimeAgo => 'Hace un tiempo';

  @override
  String get minuteAgo => 'Hace 1 minuto';

  @override
  String minutesAgo(int n) => 'Hace $n minutos';

  @override
  String get hourAgo => 'Hace 1 hora';

  @override
  String hoursAgo(int n) => 'Hace $n horas';

  @override
  String get yesterday => 'Ayer';

  @override
  String daysAgo(int n) => 'Hace $n días';

  @override
  String get monthAgo => 'Hace 1 mes';

  @override
  String monthsAgo(int n) => 'Hace $n meses';

  @override
  String get yearAgo => 'Hace 1 año';

  @override
  String yearsAgo(int n) => 'Hace $n años';

  @override
  String get close => 'Cerrar';

  @override
  String get vote => 'Votar';
}
