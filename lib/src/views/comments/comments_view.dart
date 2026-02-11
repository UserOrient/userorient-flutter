import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:userorient_flutter/src/logic/l10n.dart';
import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/models/comment.dart';
import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/utilities/localizations_overrider.dart';
import 'package:userorient_flutter/src/views/comments/comment_item.dart';
import 'package:userorient_flutter/src/views/comments/comment_text_field.dart';
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
          elevation: 0,
          surfaceTintColor: Colors.transparent,
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
                      FeatureCard.full(
                        widget.feature,
                      ),
                      if (value == null) ...[
                        const SizedBox(height: 48),
                        const Center(
                          child: StyledLoadingIndicator(),
                        ),
                      ] else if (value.isEmpty) ...[
                        const SizedBox(height: 64),
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
                            L10n.noCommentsYet,
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
                            L10n.beFirstToComment,
                            style: TextStyle(
                              fontSize: 14,
                              height: 20 / 14,
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 32),
                        for (int i = 0; i < value.length; i++) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommentItem(comment: value[i]),
                              if (value[i].replies.isNotEmpty)
                                CommentReply(comment: value[i]),
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
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    offset: const Offset(0, -4),
                    blurRadius: 24.0,
                  ),
                ],
                color: context.backgroundColor,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  CommentTextField(
                    featureId: widget.feature.id,
                  ),
                  const BottomPadding(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
