import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
            floatingActionButton: _RequestFeature(
              controller: _scrollController,
            ),
            body: Column(
              children: [
                SvgPicture.network(
                  // TODO: add upvote icon from assets
                  'https://kamranbekirov.com/upvote.svg',
                  width: .1,
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
                        features ??= List.generate(10, (index) {
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
                          child: _List(
                            features: features,
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
    return ValueListenableBuilder(
      valueListenable: UserOrient.user,
      builder: (context, User? user, _) {
        if (user == null) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Text(
                  //   _getHeaderText(user),
                  //   style: const TextStyle(
                  //     fontSize: 22.0,
                  //     height: 32 / 22,
                  //     color: Colors.white,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  // if (project?.logoUrl != null &&
                  //     !project!.logoUrl!.contains('null'))
                  //   project!.logoUrl!.contains('.svg')
                  //       ? SvgPicture.network(
                  //           project!.logoUrl!,
                  //           height: 40.0,
                  //         )
                  //       : Image.network(
                  //           project!.logoUrl!,
                  //           height: 40.0,
                  //         ),

                  Row(
                    children: [
                      if (project?.logoUrl != null &&
                          !project!.logoUrl!.contains('null')) ...[
                        Container(
                          // a border to make it differentiate from same background color
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            borderRadius: BorderRadius.circular(11.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 4,
                                blurRadius: 8,
                                offset: const Offset(
                                  -2,
                                  2,
                                ), // changes position of shadow
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
                      ],
                      AnimatedOpacity(
                        duration: kThemeAnimationDuration,
                        opacity: project != null ? 1.0 : 0.0,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            project?.name ?? '',
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const StyledCloseButton(),
                  const SizedBox(width: 8.0),
                ],
              ),
              // const SizedBox(height: 8.0),
              // const Padding(
              //   padding: EdgeInsets.only(right: 56.0),
              //   child: Text(
              //     'Aşağıdaki yeniliklərdən hansılarını daha əvvəl görmək istərdiniz?',
              //     style: TextStyle(
              //       fontSize: 18.0,
              //       height: 24 / 18,
              //       fontWeight: FontWeight.w500,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 28.0),
              // Padding(
              //   padding: const EdgeInsets.only(right: 16.0),
              //   child: Row(
              //     children: [
              //       if (project?.logoUrl != null &&
              //           !project!.logoUrl!.contains('null'))
              //         project!.logoUrl!.contains('.svg')
              //             ? SvgPicture.network(
              //                 project!.logoUrl!,
              //                 height: 40.0,
              //               )
              //             : Image.network(
              //                 project!.logoUrl!,
              //                 height: 40.0,
              //               ),
              //       const Spacer(),
              //       const _RequestButton(),
              //     ],
              //   ),
              // )
            ],
          ),
        );
      },
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

class _RequestButton extends StatelessWidget {
  const _RequestButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0,
      margin: const EdgeInsets.symmetric(horizontal: 0.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff121212),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextButton(
        onPressed: () {
          UserOrient.openForm(context);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add_circle_rounded,
              color: Colors.white,
            ),
            const SizedBox(width: 8.0),
            const Text(
              'Təklif et',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestFeature extends StatefulWidget {
  final ScrollController controller;

  const _RequestFeature({
    required this.controller,
  });

  @override
  State<_RequestFeature> createState() => _RequestFeatureState();
}

class _RequestFeatureState extends State<_RequestFeature> {
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    // hide when scrolling down, show when scrolling up
    if (widget.controller.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
        });
      }
    } else {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: kThemeAnimationDuration,
      opacity: _isVisible ? 1.0 : 0.0,
      child: AnimatedPadding(
        duration: kThemeAnimationDuration,
        padding: EdgeInsets.only(
          bottom: _isVisible ? 32 : 0,
        ),
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
    );
  }
}
