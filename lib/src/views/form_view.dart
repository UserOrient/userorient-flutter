import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/views/sent_view.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
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
            SizedBox(width: 16.0),
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
                      minLines: 6,
                      controller: _controller,
                      hintText: L10n.formHint,
                      autoFocus: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              height: 56.0,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: stringToColor(
                  UserOrient.project.value?.color,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                  });

                  UserOrient.submitForm(
                    content: _controller.text,
                  ).then((_) {
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
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: LinearProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    : Text(
                        L10n.submitForm,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            const BottomPadding(),
          ],
        ),
      ),
    );
  }
}
