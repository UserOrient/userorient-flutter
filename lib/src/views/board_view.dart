import 'package:flutter/material.dart';
import 'package:userorient_flutter/src/logic/l10n.dart';

import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/widgets/feature_card.dart';
import 'package:userorient_flutter/src/widgets/styled_close_button.dart';
import 'package:userorient_flutter/src/widgets/tip_card.dart';
import 'package:userorient_flutter/src/widgets/watermark.dart';
import 'package:userorient_flutter/userorient_flutter.dart';

class BoardView extends StatefulWidget {
  const BoardView({super.key});

  @override
  State<BoardView> createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Text(
            L10n.title,
            style: const TextStyle(
              fontSize: 20.0,
              height: 28 / 20,
              fontWeight: FontWeight.bold,
              color: Color(0xff2A2A2A),
            ),
          ),
        ),
        centerTitle: false,
        actions: const [
          StyledCloseButton.black(),
          SizedBox(width: 12.0),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: UserOrient.features,
              builder: (context, List<Feature>? features, _) {
                features ??= List.generate(7, (index) {
                  return Feature.skeleton();
                });

                return MediaQuery.removePadding(
                  context: context,
                  removeBottom: true,
                  child: Scrollbar(
                    child: _List(
                      features: features,
                    ),
                  ),
                );
              },
            ),
          ),
          const Watermark(),
        ],
      ),
    );
  }
}

class _List extends StatelessWidget {
  final List<Feature> features;

  const _List({
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 8.0,
        bottom: 16.0,
      ),
      itemCount: features.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const TipCard();
        }

        final Feature feature = features[index - 1];

        return FeatureCard(
          feature,
          isShimmer: feature.isSkeleton,
        );
      },
      separatorBuilder: (context, index) {
        if (index == 0) {
          return const SizedBox(height: 12.0);
        }

        return const SizedBox(height: 4.0);
      },
    );
  }
}
