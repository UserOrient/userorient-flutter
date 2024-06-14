import 'package:flutter/foundation.dart';
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
        backgroundColor: stringToColor(
          UserOrient.project.value?.color,
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 8.0,
            ),
            if (defaultTargetPlatform != TargetPlatform.iOS)
              const SizedBox(height: 12.0),
            const Row(
              children: [
                SizedBox(width: 24.0),
                Text(
                  'Təklif göndər',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                StyledCloseButton(),
                SizedBox(width: 20.0),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            // TODO: don't submit empty form
                            StyledTextField(
                              minLines: 6,
                              controller: _controller,
                              hintText: 'Təklifinizi detallı şəkildə qeyd edin',
                              autoFocus: true,
                            ),
                          ],
                        ),
                        // TextField(
                        //   minLines: 5,
                        //   maxLines: 8,
                        //   controller: _controller,
                        //   autofocus: true,
                        //   decoration: InputDecoration(
                        //     hintText: 'Təklifinizi detallı şəkildə qeyd edin',
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       borderSide: const BorderSide(
                        //         color: Color(0xffE4E4E4),
                        //       ),
                        //     ),
                        //     enabledBorder: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       borderSide: const BorderSide(
                        //         color: Color(0xffE4E4E4),
                        //       ),
                        //     ),
                        //     focusedBorder: GradientOutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(10.0),
                        //       gradient: const LinearGradient(
                        //         begin: Alignment.centerLeft,
                        //         end: Alignment.centerRight,
                        //         colors: [
                        //           Color(0xffFFF59F),
                        //           Color(0xffFF9B63),
                        //           Color(0xffD183AD),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Container(
                      height: 56.0,
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff121212),
                        borderRadius: BorderRadius.circular(12.0),
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
                                          borderRadius:
                                              BorderRadius.circular(12.0),
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
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
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
            ),
          ],
        ),
      ),
    );
  }
}
