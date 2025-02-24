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
      inputFormatters: const [
        CapitalizeFirstLetterFormatter(),
      ],
      style: TextStyle(
        fontSize: 18.0,
        color: context.textColor,
      ),
      cursorColor: context.textColor,
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
    );
  }
}

class CapitalizeFirstLetterFormatter extends TextInputFormatter {
  const CapitalizeFirstLetterFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String newText =
        newValue.text[0].toUpperCase() + newValue.text.substring(1);
    return newValue.copyWith(
      text: newText,
      selection: newValue.selection,
    );
  }
}
