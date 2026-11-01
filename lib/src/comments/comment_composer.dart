import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:userorient_flutter/src/comments/comments_model.dart';
import 'package:userorient_flutter/src/kit/palette.dart';
import 'package:userorient_flutter/src/kit/spinner.dart';
import 'package:userorient_flutter/src/kit/text_area.dart';
import 'package:userorient_flutter/src/l10n/userorient_strings.dart';

/// The pill-shaped field pinned under the comments, with a send button that
/// appears once there's text.
class CommentComposer extends StatefulWidget {
  final CommentsModel comments;

  const CommentComposer({super.key, required this.comments});

  @override
  State<CommentComposer> createState() => _CommentComposerState();
}

class _CommentComposerState extends State<CommentComposer> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_rebuild);
    _controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  Future<void> _send() async {
    final String content = _controller.text;
    if (content.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    await widget.comments.add(content);
    if (!mounted) return;

    _controller.clear();
    _focusNode.unfocus();
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    final Palette palette = context.palette;
    final bool isEmpty = _controller.text.isEmpty;

    return GestureDetector(
      onTap: _focusNode.requestFocus,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: isEmpty && !_focusNode.hasFocus ? 16 : 0,
        ),
        padding: const EdgeInsets.fromLTRB(18, 0, 8, 0),
        decoration: BoxDecoration(
          color: palette.field,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: EditableText(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: TextStyle(fontSize: 16, color: palette.text),
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: const [SentenceCaseFormatter()],
                    cursorColor: palette.text,
                    backgroundCursorColor: Colors.transparent,
                    onSubmitted: (_) => _send(),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                if (!isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: _send,
                      behavior: HitTestBehavior.translucent,
                      child: Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: palette.accent,
                          shape: BoxShape.circle,
                        ),
                        child: _isSending
                            ? Spinner.small(color: palette.onAccent)
                            : SvgPicture.asset(
                                'assets/add-comment.svg',
                                package: 'userorient_flutter',
                                width: 24,
                                height: 24,
                                colorFilter: ColorFilter.mode(
                                  palette.onAccent,
                                  BlendMode.srcIn,
                                ),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
            if (isEmpty)
              Positioned(
                left: 0,
                child: Text(
                  UserOrientStrings.of(context).commentHint,
                  style: TextStyle(fontSize: 16, color: palette.secondaryText),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
