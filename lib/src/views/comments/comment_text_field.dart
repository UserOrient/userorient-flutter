import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/widgets/styled_loading_indicator.dart';
import 'package:userorient_flutter/src/widgets/styled_text_field.dart';

class CommentTextField extends StatefulWidget {
  final String featureId;

  const CommentTextField({super.key, required this.featureId});

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _isLoading = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _focusNode.addListener(_onFocusChange);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.removeListener(_onTextChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    setState(() {
      // Trigger rebuild when text changes for placeholder visibility
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showPlaceholder = _controller.text.isEmpty && !_isFocused;

    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: showPlaceholder ? 16 : 0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.textFieldFillColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                // TODO:
                Expanded(
                  child: EditableText(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(
                      fontSize: 16,
                      color: context.textColor,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: const [
                      SentenceCapitalizationFormatter(),
                    ],
                    cursorColor: context.textColor,
                    backgroundCursorColor: Colors.transparent,
                    onChanged: (value) {
                      setState(() {
                        // Trigger rebuild when text changes for placeholder visibility
                      });
                    },
                    onSubmitted: (_) {
                      _addComment();
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: GestureDetector(
                      onTap: () {
                        _addComment();
                      },
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: 52,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: context.buttonColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: _isLoading
                            ? StyledLoadingIndicator.small(
                                color: context.buttonTextColor,
                              )
                            : SvgPicture.asset(
                                'assets/add-comment.svg',
                                package: 'userorient_flutter',
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  context.buttonTextColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
            // TODO: add clear
            if (showPlaceholder)
              Positioned(
                left: 0,
                child: Text(
                  L10n.addComment,
                  style: TextStyle(
                    fontSize: 16,
                    color: context.secondaryTextColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _addComment() async {
    final String comment = _controller.text;

    if (comment.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    await UserOrient.addComment(content: comment, featureId: widget.featureId);

    _controller.clear();
    _focusNode.unfocus();

    setState(() {
      _isLoading = false;
    });
  }
}
