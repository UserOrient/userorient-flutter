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
  const FormView({super.key, this.buttonColor, this.buttonTextColor});
  final Color? buttonColor;
  final Color? buttonTextColor;

  @override
  State<FormView> createState() => FormViewState();
}

class FormViewState extends State<FormView> {
  late final TextEditingController _controller;
  late final TextEditingController _titleController;
  bool _isLoading = false;

  @override
  void initState() {
    UserOrient.initialize().ignore();
    super.initState();
    _controller = TextEditingController();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _titleController.dispose();
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: StyledTextField(
              minLines: 1,
              controller: _titleController,
              hintText: L10n.addFeature,
              autoFocus: true,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: context.textColor,
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: StyledTextField(
                minLines: 20,
                controller: _controller,
                hintText: L10n.formHint,
                autoFocus: false,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          Button(
            color: widget.buttonColor,
            textColor: widget.buttonTextColor,
            onPressed: () {
              final String content = _controller.text.trim();
              final String title = _titleController.text.trim();

              if (content.isEmpty) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    elevation: 0,
                    content: Text(
                      L10n.formEmpty,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 120,
                      left: 24,
                      right: 24,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );

                return;
              }

              setState(() {
                _isLoading = true;
              });

              UserOrient.submitForm(
                content: content,
                title: title,
              ).then((_) {
                setState(() {
                  Navigator.pop(context);
                  Navigation.push(
                      context,
                      SentView(
                        buttonColor: widget.buttonColor,
                        buttonTextColor: widget.buttonTextColor,
                      ));
                });
              });
            },
            busy: _isLoading,
            label: L10n.submitForm,
          ),
          const BottomPadding(),
        ],
      ),
    );
  }
}
