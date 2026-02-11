import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/models/comment.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/date_time_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/widgets/bottom_padding.dart';
import 'package:userorient_flutter/src/widgets/feature_card.dart';
import 'package:userorient_flutter/src/widgets/styled_back_button.dart';
import 'package:userorient_flutter/src/widgets/styled_loading_indicator.dart';

class CommentsView extends StatefulWidget {
  final Feature feature;

  const CommentsView({
    super.key,
    required this.feature,
  });

  @override
  State<CommentsView> createState() => CommentsViewState();
}

class CommentsViewState extends State<CommentsView> {
  @override
  void initState() {
    super.initState();
    UserOrient.getComments(widget.feature);
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationsOverrider(
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          automaticallyImplyLeading: false,
          leading: const StyledBackButton(),
          centerTitle: true,
          title: Text(
            L10n.comments,
            style: TextStyle(
              fontSize: 18,
              height: 26 / 18,
              color: context.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder<List<Comment>?>(
                valueListenable: UserOrient.comments,
                builder: (context, value, child) {
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    children: [
                      FeatureCard.full(widget.feature),
                      if (value == null) ...[
                        const SizedBox(height: 48),
                        const Center(child: StyledLoadingIndicator()),
                      ] else if (value.isEmpty) ...[
                        const SizedBox(height: 48),
                        Center(
                          child: SizedBox(
                            width: 48,
                            height: 48,
                            child: SvgPicture.asset(
                              'assets/comments-empty.svg',
                              package: 'userorient_flutter',
                              colorFilter: ColorFilter.mode(
                                context.secondaryTextColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'No comments yet',
                            style: TextStyle(
                              fontSize: 18,
                              height: 28 / 18,
                              color: context.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Be the first to comment on this feature',
                            style: TextStyle(
                              fontSize: 14,
                              height: 20 / 14,
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 24),
                        for (int i = 0; i < value.length; i++) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Item(comment: value[i]),
                              if (value[i].replies.isNotEmpty)
                                _Reply(comment: value[i]),
                            ],
                          ),
                          if (i < value.length - 1)
                            Divider(
                              color: context.borderColor,
                              height: 32,
                            ),
                        ],
                      ],
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24.0),
            _TextField(
              featureId: widget.feature.id,
            ),
            const BottomPadding(),
          ],
        ),
      ),
    );
  }
}

class _Reply extends StatelessWidget {
  final Comment comment;

  const _Reply({
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: context.borderColor,
              width: 2,
            ),
          ),
        ),
        child: _Item.developer(
          comment: comment.replies.first,
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final Comment comment;

  const _Item({
    required this.comment,
  }) : _isDeveloper = false;

  const _Item.developer({
    required this.comment,
  }) : _isDeveloper = true;

  final bool _isDeveloper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              comment.ownerFullName ?? 'Guest User',
              style: TextStyle(
                fontSize: 16,
                height: 24 / 16,
                color: context.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_isDeveloper) ...[
              const SizedBox(width: 4),
              SvgPicture.asset(
                'assets/checkmark.svg',
                package: 'userorient_flutter',
                width: 16,
                colorFilter: ColorFilter.mode(
                  context.votedContainerColor,
                  BlendMode.srcIn,
                ),
              )
            ],
          ],
        ),
        Text(
          comment.createdAt?.timeAgoWithAllEdgeCases() ?? 'Some time ago',
          style: TextStyle(
            fontSize: 12,
            height: 16 / 12,
            color: context.secondaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          comment.content ?? 'N/A',
          style: TextStyle(
            fontSize: 14,
            height: 20 / 14,
            color: context.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}

class _TextField extends StatefulWidget {
  final String featureId;

  const _TextField({required this.featureId});

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
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
            AnimatedSize(
              duration: kThemeAnimationDuration,
              curve: Curves.ease,
              child: Row(
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
            ),
            // TODO: add clear
            if (showPlaceholder)
              Positioned(
                left: 0,
                child: Text(
                  'Add a comment...',
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
    setState(() {
      _isLoading = true;
    });
    await UserOrient.addComment(
      content: _controller.text,
      featureId: widget.featureId,
    );
    _controller.clear();
    _focusNode.unfocus();
    setState(() {
      _isLoading = false;
    });
  }
}
