import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/models/collection_mode.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/utilities/navigation.dart';
import 'package:userorient_flutter/src/utilities/sheet_dismiss.dart';
import 'package:userorient_flutter/src/views/form/email_view.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/button.dart';
import 'package:userorient_flutter/src/widgets/sheet_title.dart';
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
      _isEmpty = _controller.text.trim().length < 10;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool get _hasEmail =>
      UserOrient.user?.email != null ||
      UserOrient.dataCollection.email == CollectionMode.notCollected;

  Widget _buildSubmitButton(BuildContext context) {
    if (_hasEmail) {
      if (UserOrient.dataCollection.email == CollectionMode.notCollected) {
        logUO('Email view skipped (notCollected)', emoji: '📧');
      } else {
        logUO('Email view skipped (email already set)', emoji: '📧');
      }

      return Button(
        onPressed: () {
          final String content = _controller.text.trim();
          if (content.length < 10) return;

          setState(() {
            _isLoading = true;
          });

          // The board pins the request on its own once it's sent.
          final VoidCallback dismiss = SheetDismiss.of(context);
          UserOrient.submitForm(content: content).then((_) {
            if (context.mounted) dismiss();
          });
        },
        label: L10n.submitForm,
        busy: _isLoading,
        disabled: _isEmpty,
        iconAffinity: IconAffinity.trailing,
        icon: Icon(
          Icons.arrow_upward,
          size: 20,
          color:
              _isEmpty ? context.secondaryTextColor : context.buttonTextColor,
        ),
      );
    }

    final bool emailRequired =
        UserOrient.dataCollection.email == CollectionMode.required;

    logUO(
      'Showing email view (${emailRequired ? 'required' : 'optional'})',
      emoji: '📧',
    );

    return Button(
      onPressed: () {
        final String content = _controller.text.trim();
        if (content.length < 10) return;

        final VoidCallback dismiss = SheetDismiss.of(context);
        Navigation.push(
          context,
          EmailView(content: content, required: emailRequired),
        ).then((submitted) {
          if (submitted == true && context.mounted) dismiss();
        });
      },
      label: L10n.next,
      disabled: _isEmpty,
      iconAffinity: IconAffinity.trailing,
      icon: Icon(
        Icons.arrow_forward,
        size: 20,
        color: _isEmpty ? context.secondaryTextColor : context.buttonTextColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationsOverrider(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SheetTitle(text: L10n.addFeature),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      '${_controller.text.trim().length}/500',
                      style: TextStyle(
                        fontSize: 14,
                        fontFeatures: const [
                          FontFeature.tabularFigures(),
                        ],
                        color: _controller.text.trim().isEmpty
                            ? context.secondaryTextColor.withValues(alpha: 0.5)
                            : _controller.text.trim().length < 10
                                ? Colors.red
                                : context.secondaryTextColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  _buildSubmitButton(context),
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
