import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/navigation.dart';
import 'package:userorient_flutter/src/views/sent_view.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/button.dart';
import 'package:userorient_flutter/src/widgets/styled_close_button.dart';
import 'package:userorient_flutter/src/widgets/styled_text_field.dart';

class FormView extends StatefulWidget {
  const FormView({super.key});

  @override
  State<FormView> createState() => FormViewState();
}

class FormViewState extends State<FormView> {
  late final TextEditingController _controller;
  bool _isLoading = false;
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isEmpty = _controller.text.trim().length < 8;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          L10n.addFeature,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            color: context.textColor,
          ),
        ),
        actions: const [
          StyledCloseButton(),
          SizedBox(width: 12.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                children: [
                  Expanded(
                    child: StyledTextField(
                      minLines: 20,
                      controller: _controller,
                      hintText: L10n.formHint,
                      autoFocus: true,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0, top: 8.0),
                      child: Text(
                        '${_controller.text.trim().length}/500',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: _controller.text.trim().length == 0
                              ? context.secondaryTextColor.withOpacity(0.5)
                              : _controller.text.trim().length < 8
                                  ? Colors.red
                                  : context.secondaryTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Button(
            onPressed: () {
              final String content = _controller.text.trim();

              if (content.length < 8) return;

              setState(() {
                _isLoading = true;
              });

              UserOrient.submitForm(content: content).then((_) {
                setState(() {
                  Navigator.pop(context);
                  Navigation.push(context, const SentView());
                });
              });
            },
            busy: _isLoading,
            disabled: _isEmpty,
            label: L10n.submitForm,
          ),
          const BottomPadding(),
        ],
      ),
    );
  }
}
