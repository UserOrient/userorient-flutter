import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';

class StyledTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final int minLines;
  final bool autoFocus;
  final String? helperText;
  final int? maxLength;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  const StyledTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.autoFocus = false,
    this.minLines = 1,
    this.helperText,
    this.maxLength,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmail = keyboardType == TextInputType.emailAddress;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: context.buttonColor.withValues(alpha: 0.2),
          selectionHandleColor: context.buttonColor,
        ),
      ),
      child: TextField(
      minLines: minLines,
      maxLines: minLines,
      autofocus: autoFocus,
      maxLength: maxLength,
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization:
          isEmail ? TextCapitalization.none : TextCapitalization.sentences,
      inputFormatters: isEmail
          ? null
          : const [
              SentenceCapitalizationFormatter(),
            ],
      style: TextStyle(
        fontSize: 18.0,
        color: context.textColor,
      ),
      cursorHeight: 20,
      cursorColor: context.textColor,
      decoration: InputDecoration(
        hintText: hintText,
        filled: false,
        fillColor: Colors.transparent,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        labelText: label,
        hintStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
          color: context.secondaryTextColor,
        ),
        labelStyle: TextStyle(
          fontSize: 14.0,
          color: context.textColor,
        ),
        ),
      ),
    );
  }
}

class SentenceCapitalizationFormatter extends TextInputFormatter {
  const SentenceCapitalizationFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final chars = newValue.text.split('');
    bool capitalizeNext = true;

    for (int i = 0; i < chars.length; i++) {
      if (capitalizeNext && chars[i].trim().isNotEmpty) {
        chars[i] = chars[i].toUpperCase();
        capitalizeNext = false;
      }
      if (chars[i] == '.' && i + 1 < chars.length && chars[i + 1] == ' ') {
        capitalizeNext = true;
      }
    }

    final newText = chars.join();
    return newValue.copyWith(text: newText, selection: newValue.selection);
  }
}
