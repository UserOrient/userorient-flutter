import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            L10n.formTitle,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: const [
            StyledCloseButton.black(),
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
                    const SizedBox(height: 8.0),
                    // TODO: don't submit empty form
                    StyledTextField(
                      minLines: 10,
                      controller: _controller,
                      hintText: L10n.formHint,
                      autoFocus: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Button(
              onPressed: () {
                final String content = _controller.text.trim();

                setState(() {
                  _isLoading = true;
                });

                UserOrient.submitForm(content: content).then((_) {
                  setState(() {
                    Navigator.pop(context);

                    showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: 'UserOrient',
                      transitionDuration: kThemeAnimationDuration,
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const SentView();
                      },
                    );
                  });
                });
              },
              busy: _isLoading,
              label: L10n.submitForm,
            ),
            const BottomPadding(),
          ],
        ),
      ),
    );
  }
}
