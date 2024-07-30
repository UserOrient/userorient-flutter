import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final int minLines;
  final bool autoFocus;
  final String? helperText;
  final int? maxLength;
  final TextEditingController controller;

  const StyledTextField({
    super.key,
    required this.controller,
    this.label,
    this.hintText,
    this.autoFocus = false,
    this.minLines = 1,
    this.helperText,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      minLines: minLines,
      maxLines: minLines,
      autofocus: autoFocus,
      maxLength: maxLength,
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      inputFormatters: [
        CapitalLetterInputFormatter(),
      ],
      style: const TextStyle(
        fontSize: 18.0,
        color: Color(0xff2A2A2A),
      ),
      decoration: InputDecoration(
        hintText: hintText,
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
        hintStyle: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
          color: Color(0xffCDCDCD),
        ),
        labelStyle: const TextStyle(
          fontSize: 14.0,
          color: Color(0xffBBBBBB),
        ),
      ),
    );
  }
}

class CapitalLetterInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final StringBuffer newText = StringBuffer();
    final List<String> words = newValue.text.split(' ');

    for (int i = 0; i < words.length; i++) {
      final String word = words[i];

      if (word.isNotEmpty) {
        newText.write(word[0].toUpperCase());

        if (word.length > 1) {
          newText.write(word.substring(1).toLowerCase());
        }
      }

      if (i < words.length - 1) {
        newText.write(' ');
      }
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: newValue.selection,
    );
  }
}
