import 'package:flutter/material.dart';

import 'package:userorient_flutter/src/logic/user_orient.dart';
import 'package:userorient_flutter/src/utilities/build_context_extensions.dart';
import 'package:userorient_flutter/src/views/board/pending_request_card.dart';

/// The user's requests still in review, pinned above the board and spaced
/// like its rows. Grows in when a new one arrives after the form closes.
class PendingRequests extends StatelessWidget {
  const PendingRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: UserOrient.pendingRequests,
      builder: (context, requests, _) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          alignment: Alignment.topCenter,
          child: requests.isEmpty
              ? const SizedBox(width: double.infinity)
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      for (final String request in requests) ...[
                        PendingRequestCard(request),
                        Divider(color: context.borderColor, height: 1),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }
}
