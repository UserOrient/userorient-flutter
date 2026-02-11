import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/button.dart';
import 'package:userorient_flutter/src/widgets/styled_back_button.dart';
import 'package:userorient_flutter/src/widgets/styled_text_field.dart';

class EmailView extends StatefulWidget {
  final String content;

  const EmailView({super.key, required this.content});

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isValid {
    final text = _controller.text.trim();
    if (text.isEmpty) return true;
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
        appBar: AppBar(
          leading: const StyledBackButton(),
          backgroundColor: context.backgroundColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            L10n.emailPromptTitle,
            style: TextStyle(
              fontSize: 18,
              color: context.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  if (!_isValid)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          L10n.invalidEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    )
                  else
                    const Spacer(),
                  Button(
                    onPressed: _submit,
                    label: _controller.text.trim().isEmpty
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
