import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/kit/bottom_inset.dart';
import 'package:userorient_flutter/src/kit/button.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/sheet_header.dart';
import 'package:userorient_flutter/src/kit/text_area.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';
import 'package:userorient_flutter/src/request/email_step.dart';
import 'package:userorient_flutter/src/request/request_model.dart';
import 'package:userorient_flutter/src/stage/stage.dart';
import 'package:userorient_flutter/src/support/log.dart';
import 'package:userorient_flutter/src/userorient_scope.dart';

/// First step of a feature request: what the user wants. Sends right away,
/// or moves on to [EmailStep] when an email is still needed.
class MessageStep extends StatefulWidget {
  const MessageStep({super.key});

  @override
  State<MessageStep> createState() => _MessageStepState();
}

class _MessageStepState extends State<MessageStep> {
  final TextEditingController _controller = TextEditingController();
  late final RequestModel _request;
  bool _isSending = false;

  String get _message => _controller.text.trim();
  bool get _isTooShort => _message.length < RequestModel.minLength;

  @override
  void initState() {
    super.initState();
    _request = RequestModel.of(UserOrientScope.of(context));
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// The board pins the request on its own once it's sent.
  Future<void> _send() async {
    if (_isTooShort) return;

    setState(() => _isSending = true);
    await _request.send(_message);

    if (mounted) Stage.dismiss(context);
  }

  Future<void> _askForEmail() async {
    if (_isTooShort) return;

    final bool? sent = await Stage.of(context).push<bool>(
      context,
      EmailStep(request: _request, message: _message),
    );

    if (sent == true && mounted) Stage.dismiss(context);
  }

  @override
  Widget build(BuildContext context) {
    final UserOrientStrings strings = UserOrientStrings.of(context);
    final Palette palette = context.palette;

    return Scaffold(
      backgroundColor: palette.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader(text: strings.suggestFeature),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextArea(
                minLines: 20,
                controller: _controller,
                hintText: strings.requestHint,
                autoFocus: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Text(
                  '${_message.length}/${RequestModel.maxLength}',
                  style: TextStyle(
                    fontSize: 14,
                    fontFeatures: const [FontFeature.tabularFigures()],
                    color: _message.isEmpty
                        ? palette.secondaryText.withValues(alpha: 0.5)
                        : _isTooShort
                            ? Colors.red
                            : palette.secondaryText,
                  ),
                ),
                const Spacer(),
                _submitButton(strings, palette),
              ],
            ),
          ),
          const BottomInset(),
        ],
      ),
    );
  }

  Widget _submitButton(UserOrientStrings strings, Palette palette) {
    final Color iconColor =
        _isTooShort ? palette.secondaryText : palette.onAccent;

    if (!_request.asksForEmail) {
      logUO('Email step skipped', emoji: '📧');

      return Button(
        onPressed: _send,
        label: strings.submit,
        busy: _isSending,
        disabled: _isTooShort,
        iconAffinity: IconAffinity.trailing,
        icon: Icon(Icons.arrow_upward, size: 20, color: iconColor),
      );
    }

    return Button(
      onPressed: _askForEmail,
      label: strings.next,
      disabled: _isTooShort,
      iconAffinity: IconAffinity.trailing,
      icon: Icon(Icons.arrow_forward, size: 20, color: iconColor),
    );
  }
}
