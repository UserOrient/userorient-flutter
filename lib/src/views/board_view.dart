import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svg;

import 'package:userorient_flutter/src/models/feature.dart';
import 'package:userorient_flutter/src/models/project.dart';
import 'package:userorient_flutter/src/utilities/helper_functions.dart';
import 'package:userorient_flutter/src/widgets/feature_card.dart';
import 'package:userorient_flutter/src/widgets/image_fade.dart';
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
    return ValueListenableBuilder<Project?>(
      valueListenable: UserOrient.project,
      builder: (context, Project? project, _) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: stringToColor(project?.color),
            body: Column(
              children: [
                SvgPicture.network(
                  // TODO: add upvote icon from assets
                  'https://kamranbekirov.com/upvote.svg',
                  width: .1,
                  height: .1,
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 8.0,
                ),
                if (defaultTargetPlatform != TargetPlatform.iOS)
                  const SizedBox(height: 12.0),
                _Header(
                  project: project,
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
                    child: ValueListenableBuilder(
                      valueListenable: UserOrient.features,
                      builder: (context, List<Feature>? features, _) {
                        features ??= List.generate(7, (index) {
                          return Feature.skeleton();
                        });

                        return SingleChildScrollView(
                          padding: const EdgeInsets.only(
                            left: 16.0,
                            right: 16.0,
                            top: 20.0,
                            bottom: 80.0,
                          ),
                          controller: _scrollController,
                          child: Column(
                            children: [
                              _List(
                                features: features,
                              ),
                              const SizedBox(height: 64.0),
                              const _RequestFeature(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Watermark(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final Project? project;

  const _Header({
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Row(
            children: [
              if (project?.logoUrl != null) ...[
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 4,
                        blurRadius: 8,
                        offset: const Offset(-2, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(1.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: project!.logoUrl!.contains('.svg') == false
                        ? ImageFade(
                            image: NetworkImage(project!.logoUrl!),
                          )
                        : ImageFade(
                            image: svg.Svg(
                              project!.logoUrl!,
                              source: svg.SvgSource.network,
                              size: const Size(40.0, 40.0),
                            ),
                            height: 40.0,
                            width: 40.0,
                          ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Text(
                  project?.name ?? '',
                  key: ValueKey(project?.name),
                  style: const TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]
            ],
          ),
          const Spacer(),
          const StyledCloseButton(),
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
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
          return const SizedBox(height: 0.0);
        }

        return const Divider(
          height: 32.0,
          thickness: 1.0,
          color: Color(0xffF4F4F6),
        );
      },
    );
  }
}

class _RequestFeature extends StatelessWidget {
  const _RequestFeature();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          const Text(
            'Təklifiniz siyahıda yoxdur?',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color(0xff121212),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Yazılı şəkildə təkliflərinizi bizə bildirin, ən qısa zamanda tətbiq etməyə çalışacağıq.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.0,
              color: const Color(0xff121212).withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16.0),
          Align(
            alignment: Alignment.center,
            child: FloatingActionButton.extended(
              backgroundColor: const Color(0xff121212),
              onPressed: () {
                UserOrient.openForm(context);
              },
              label: const Text(
                'Təklif et',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
