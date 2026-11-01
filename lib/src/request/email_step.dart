import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/kit/bottom_inset.dart';
import 'package:userorient_flutter/src/kit/button.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/sheet_header.dart';
import 'package:userorient_flutter/src/kit/text_area.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';
import 'package:userorient_flutter/src/request/request_model.dart';
import 'package:userorient_flutter/src/support/log.dart';

/// Second step, only when the email isn't known yet. Optional unless the
/// app requires it. Pops with true once the request is sent.
class EmailStep extends StatefulWidget {
  final RequestModel request;
  final String message;

  const EmailStep({super.key, required this.request, required this.message});

  @override
  State<EmailStep> createState() => _EmailStepState();
}

class _EmailStepState extends State<EmailStep> {
  static final RegExp _emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;
  bool _hasTyped = false;

  bool get _isRequired => widget.request.emailRequired;
  String get _email => _controller.text.trim();

  bool get _isValid {
    if (_email.isEmpty) return !_isRequired;
    return _emailPattern.hasMatch(_email);
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.text.isNotEmpty) _hasTyped = true;
      setState(() {});
    });

    logUO(
      'Email is ${_isRequired ? 'required' : 'optional (skip allowed)'}',
      emoji: '📧',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_isValid) return;

    setState(() => _isSending = true);
    await widget.request.send(
      widget.message,
      email: _email.isEmpty ? null : _email,
    );

    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final UserOrientStrings strings = UserOrientStrings.of(context);
    final Palette palette = context.palette;

    final Widget hint;
    if (!_isValid && _hasTyped) {
      hint = Text(
        strings.invalidEmail,
        style: const TextStyle(fontSize: 14, color: Colors.red),
      );
    } else if (_isRequired && _email.isEmpty && !_hasTyped) {
      hint = Text(
        strings.emailRequired,
        style: TextStyle(fontSize: 14, color: palette.secondaryText),
      );
    } else {
      hint = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader(text: strings.emailTitle),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextArea(
                minLines: 20,
                controller: _controller,
                hintText: strings.emailHint,
                autoFocus: true,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(child: hint),
                Button(
                  onPressed: _send,
                  label: _email.isEmpty && !_isRequired
                      ? strings.skipAndSend
                      : strings.send,
                  busy: _isSending,
                  disabled: !_isValid,
                  iconAffinity: IconAffinity.trailing,
                  icon: Icon(
                    Icons.arrow_upward,
                    size: 20,
                    color: _isValid ? palette.onAccent : palette.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const BottomInset(),
        ],
      ),
    );
  }
}
