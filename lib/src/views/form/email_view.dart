import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/button.dart';
import 'package:userorient_flutter/src/widgets/sheet_title.dart';
import 'package:userorient_flutter/src/widgets/styled_text_field.dart';

class EmailView extends StatefulWidget {
  final String content;
  final bool isRequired;

  const EmailView({super.key, required this.content, bool required = false})
      : isRequired = required;

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  late final TextEditingController _controller;
  bool _isLoading = false;
  bool _hasInteracted = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);

    logUO(
      'Email is ${widget.isRequired ? 'required' : 'optional (skip allowed)'}',
      emoji: '📧',
    );
  }

  void _onTextChanged() {
    if (!_hasInteracted && _controller.text.isNotEmpty) {
      _hasInteracted = true;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isRequired => widget.isRequired;

  bool get _isValid {
    final text = _controller.text.trim();
    if (text.isEmpty) return !_isRequired;
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(text);
  }

  void _submit() {
    if (!_isValid) return;

    final String email = _controller.text.trim();

    setState(() {
      _isLoading = true;
    });

    UserOrient.submitForm(
      content: widget.content,
      email: email.isEmpty ? null : email,
    ).then((_) {
      if (!mounted) return;
      Navigator.pop(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationsOverrider(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetTitle(text: L10n.emailPromptTitle),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: StyledTextField(
                        minLines: 20,
                        controller: _controller,
                        hintText: L10n.emailHint,
                        autoFocus: true,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  if (!_isValid && _hasInteracted)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          L10n.invalidEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  else if (_isRequired &&
                      _controller.text.trim().isEmpty &&
                      !_hasInteracted)
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.zero,
                        child: Text(
                          L10n.emailRequired,
                          style: TextStyle(
                            fontSize: 14,
                            color: context.secondaryTextColor,
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  Button(
                    onPressed: _submit,
                    label: _controller.text.trim().isEmpty && !_isRequired
                        ? L10n.skipAndSend
                        : L10n.send,
                    busy: _isLoading,
                    disabled: !_isValid,
                    iconAffinity: IconAffinity.trailing,
                    icon: Icon(
                      Icons.arrow_upward,
                      size: 20,
                      color: _isValid
                          ? context.buttonTextColor
                          : context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const BottomPadding(),
          ],
        ),
      ),
    );
  }
}
