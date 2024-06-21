import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
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
            'Təklif göndər',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            StyledCloseButton.black(),
            const SizedBox(width: 16.0),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8.0),
                    // TODO: don't submit empty form
                    StyledTextField(
                      minLines: 6,
                      controller: _controller,
                      hintText: 'Təklifinizi detallı şəkildə qeyd edin...',
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
                      _isLoading = false;
                      Navigator.pop(context);

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                            content: const Padding(
                              padding: EdgeInsets.only(top: 24.0),
                              child: Text(
                                'Təklifiniz göndərildi. Təşəkkürlər!',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            actionsPadding: const EdgeInsets.only(
                              bottom: 24.0,
                              top: 8.0,
                            ),
                            actions: [
                              Container(
                                height: 56.0,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 24.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Bağla',
                                    style: TextStyle(
                                      color: Color(0xff121212),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
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
                    : const Text(
                        'Göndər',
                        style: TextStyle(
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
