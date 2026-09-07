import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/about_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/hero_section.dart';
import '../widgets/navbar.dart';
import '../widgets/space_background.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({
    super.key,
  });

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final ScrollController _scrollController =
      ScrollController();

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey showcaseKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ==========================================================================
  // SCROLL
  // ==========================================================================

  void _scrollTo(GlobalKey key) {
    final BuildContext? targetContext =
        key.currentContext;

    if (targetContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      targetContext,
      duration:
          const Duration(milliseconds: 850),
      curve:
          Curves.easeInOutCubic,
      alignment: 0.04,
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent,

      body: SpaceBackground(
          child: Stack(
            children: [
              // ================================================================
              // SCROLL CONTENT
              // ================================================================

              SingleChildScrollView(
                controller:
                    _scrollController,

                physics:
                    const BouncingScrollPhysics(),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,

                  children: [
                    // ==========================================================
                    // HERO
                    // ==========================================================

                    SizedBox(
                      key: homeKey,
                      width:
                          double.infinity,

                      child: HeroSection(
                        onViewProjects: () {
                          _scrollTo(
                            showcaseKey,
                          );
                        },

                        onContact: () {
                          _scrollTo(
                            contactKey,
                          );
                        },
                      ),
                    ),

                    // ==========================================================
                    // ABOUT
                    // ==========================================================

                    SizedBox(
                      key: aboutKey,
                      width:
                          double.infinity,

                      child: _ScrollReveal(
                        scrollController:
                            _scrollController,

                        child:
                            const AboutSection(),
                      ),
                    ),

                    // ==========================================================
                    // PORTFOLIO
                    // ==========================================================

                    SizedBox(
                      key: showcaseKey,
                      width:
                          double.infinity,

                      child: _ScrollReveal(
                        scrollController:
                            _scrollController,

                        delay:
                            const Duration(
                          milliseconds: 120,
                        ),

                        child:
                            const _PortfolioShowcase(),
                      ),
                    ),

                    // ==========================================================
                    // CONTACT
                    // ==========================================================

                    SizedBox(
                      key: contactKey,
                      width:
                          double.infinity,

                      child: _ScrollReveal(
                        scrollController:
                            _scrollController,

                        delay:
                            const Duration(
                          milliseconds: 120,
                        ),

                        child:
                            const ContactSection(),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),

              // ==============================================================
              // NAVBAR
              // ==============================================================

              Positioned(
                top: 0,
                left: 0,
                right: 0,

                child: Navbar(
                  onHome: () {
                    _scrollTo(
                      homeKey,
                    );
                  },

                  onAbout: () {
                    _scrollTo(
                      aboutKey,
                    );
                  },

                  onSkills: () {
                    _scrollTo(
                      showcaseKey,
                    );
                  },

                  onProjects: () {
                    _scrollTo(
                      showcaseKey,
                    );
                  },

                  onCertificates: () {
                    _scrollTo(
                      showcaseKey,
                    );
                  },

                  onContact: () {
                    _scrollTo(
                      contactKey,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}

// ============================================================================
// SCROLL REVEAL
// ============================================================================

class _ScrollReveal
    extends StatefulWidget {
  final ScrollController scrollController;
  final Widget child;
  final Duration delay;

  const _ScrollReveal({
    required this.scrollController,
    required this.child,
    this.delay =
        const Duration(
      milliseconds: 80,
    ),
  });

  @override
  State<_ScrollReveal> createState() =>
      _ScrollRevealState();
}

class _ScrollRevealState
    extends State<_ScrollReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController
      _controller;

  late final Animation<double>
      _opacity;

  late final Animation<Offset>
      _slide;

  Timer? _delayTimer;

  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
      vsync: this,
      duration:
          const Duration(
        milliseconds: 700,
      ),
      reverseDuration:
          const Duration(
        milliseconds: 450,
      ),
    );

    final CurvedAnimation curve =
        CurvedAnimation(
      parent: _controller,
      curve:
          Curves.easeOutCubic,
      reverseCurve:
          Curves.easeInCubic,
    );

    _opacity =
        Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      curve,
    );

    _slide =
        Tween<Offset>(
      begin:
          const Offset(
        0,
        0.10,
      ),
      end:
          Offset.zero,
    ).animate(
      curve,
    );

    widget.scrollController
        .addListener(
      _onScroll,
    );

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        _checkVisibility();
      },
    );
  }

  @override
  void didUpdateWidget(
    covariant _ScrollReveal
        oldWidget,
  ) {
    super.didUpdateWidget(
      oldWidget,
    );

    if (oldWidget
            .scrollController !=
        widget.scrollController) {
      oldWidget
          .scrollController
          .removeListener(
        _onScroll,
      );

      widget
          .scrollController
          .addListener(
        _onScroll,
      );
    }

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        _checkVisibility();
      },
    );
  }

  void _onScroll() {
    _checkVisibility();
  }

  void _checkVisibility() {
    if (!mounted) {
      return;
    }

    final RenderObject?
        renderObject =
        context.findRenderObject();

    if (renderObject
            is! RenderBox ||
        !renderObject.hasSize) {
      return;
    }

    final double top =
        renderObject
            .localToGlobal(
          Offset.zero,
        )
            .dy;

    final double bottom =
        top +
            renderObject.size.height;

    final double
        viewportHeight =
        MediaQuery.sizeOf(
          context,
        ).height;

    final bool visible =
        bottom > 85 &&
            top <
                viewportHeight *
                    0.92;

    if (visible &&
        !_isVisible) {
      _isVisible = true;

      _delayTimer
          ?.cancel();

      if (_controller
              .status !=
          AnimationStatus
              .completed) {
        _delayTimer =
            Timer(
          widget.delay,
          () {
            if (mounted &&
                _isVisible) {
              _controller
                  .forward();
            }
          },
        );
      }
    } else if (!visible &&
        _isVisible) {
      _isVisible = false;

      _delayTimer
          ?.cancel();

      _controller.reverse();
    }
  }

  @override
  void dispose() {
    widget.scrollController
        .removeListener(
      _onScroll,
    );

    _delayTimer?.cancel();

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return FadeTransition(
      opacity:
          _opacity,

      child:
          SlideTransition(
        position:
            _slide,

        child:
            widget.child,
      ),
    );
  }
}

// ============================================================================
// PORTFOLIO SHOWCASE
// ============================================================================

class _PortfolioShowcase
    extends StatefulWidget {
  const _PortfolioShowcase();

  @override
  State<_PortfolioShowcase>
      createState() =>
          _PortfolioShowcaseState();
}

class _PortfolioShowcaseState
    extends State<
        _PortfolioShowcase> {
  int selectedTab = 0;

  static const Color white =
      Color(0xFFF5F5F5);

  static const Color muted =
      Color(0xFF999999);

  static const Color surface =
      Color(0xFF171717);

  static const Color surfaceLight =
      Color(0xFF303030);

  static const Color border =
      Color(0xFF383838);

  @override
  Widget build(
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final bool mobile =
            constraints.maxWidth <
                750;

        return Padding(
          padding:
              EdgeInsets.fromLTRB(
            mobile ? 20 : 60,
            mobile ? 55 : 70,
            mobile ? 20 : 60,
            mobile ? 60 : 75,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 1400,
              ),

              child: Column(
                children: [
                  // ==========================================================
                  // TITLE
                  // ==========================================================

                  Text(
                    'Portofolio',

                    textAlign:
                        TextAlign.center,

                    style:
                        GoogleFonts.dmSans(
                      color:
                          white,

                      fontSize:
                          mobile
                              ? 38
                              : 60,

                      fontWeight:
                          FontWeight
                              .w800,

                      letterSpacing:
                          -2.8,

                      height: 1,
                    ),
                  ),

                  const SizedBox(
                    height: 18,
                  ),

                  Text(
                    'Lihat berbagai proyek, sertifikasi, dan '
                    'keahlian teknis yang telah saya kerjakan.',

                    textAlign:
                        TextAlign.center,

                    style:
                        GoogleFonts.dmSans(
                      color:
                          muted,

                      fontSize:
                          mobile
                              ? 13
                              : 16,

                      height:
                          1.5,
                    ),
                  ),

                  SizedBox(
                    height:
                        mobile
                            ? 24
                            : 30,
                  ),

                  SizedBox(
                    height:
                        mobile
                            ? 28
                            : 40,
                  ),

                  _buildTabs(
                    mobile,
                  ),

                  SizedBox(
                    height:
                        mobile
                            ? 28
                            : 38,
                  ),

                  // ==========================================================
                  // TAB CONTENT
                  // ==========================================================

                  AnimatedSwitcher(
                    duration:
                        const Duration(
                      milliseconds:
                          280,
                    ),

                    switchInCurve:
                        Curves
                            .easeOutCubic,

                    switchOutCurve:
                        Curves
                            .easeInCubic,

                    transitionBuilder:
                        (
                      child,
                      animation,
                    ) {
                      return FadeTransition(
                        opacity:
                            animation,

                        child:
                            SlideTransition(
                          position:
                              Tween<
                                  Offset>(
                            begin:
                                const Offset(
                              0,
                              0.025,
                            ),
                            end:
                                Offset.zero,
                          ).animate(
                            animation,
                          ),

                          child:
                              child,
                        ),
                      );
                    },

                    child:
                        _buildContent(
                      mobile,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // TABS
  // ==========================================================================

  Widget _buildTabs(
    bool mobile,
  ) {
    const List<String> labels = [
      'Proyek',
      'Sertifikat',
      'Keahlian',
    ];

    return Container(
      height:
          mobile ? 54 : 64,

      width:
          double.infinity,

      constraints:
          const BoxConstraints(
        maxWidth: 1080,
      ),

      padding:
          const EdgeInsets.all(4),

      decoration:
          BoxDecoration(
        color:
            surface,

        borderRadius:
            BorderRadius.circular(
          100,
        ),

        border:
            Border.all(
          color:
              border,
        ),
      ),

      child: Row(
        children:
            List.generate(
          labels.length,
          (index) {
            final bool active =
                selectedTab ==
                    index;

            return Expanded(
              child:
                  GestureDetector(
                onTap: () {
                  setState(
                    () {
                      selectedTab =
                          index;
                    },
                  );
                },

                child:
                    AnimatedContainer(
                  duration:
                      const Duration(
                    milliseconds:
                        220,
                  ),

                  curve:
                      Curves
                          .easeOutCubic,

                  alignment:
                      Alignment.center,

                  decoration:
                      BoxDecoration(
                    color: active
                        ? surfaceLight
                        : Colors
                            .transparent,

                    borderRadius:
                        BorderRadius
                            .circular(
                      100,
                    ),

                    border: active
                        ? Border.all(
                            color:
                                white,
                            width:
                                1.4,
                          )
                        : null,
                  ),

                  child:
                      Text(
                    labels[index],

                    style:
                        GoogleFonts.dmSans(
                      color: active
                          ? white
                          : muted,

                      fontSize:
                          mobile
                              ? 12
                              : 15,

                      fontWeight:
                          active
                              ? FontWeight
                                  .w700
                              : FontWeight
                                  .w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================================================
  // TAB CONTENT
  // ==========================================================================

  Widget _buildContent(
    bool mobile,
  ) {
    switch (
        selectedTab) {
      case 1:
        return _CertificatesContent(
          key:
              const ValueKey(
            'sertifikat',
          ),
          mobile:
              mobile,
        );

      case 2:
        return _SkillsContent(
          key:
              const ValueKey(
            'keahlian',
          ),
          mobile:
              mobile,
        );

      default:
        return _ProjectsContent(
          key:
              const ValueKey(
            'proyek',
          ),
          mobile:
              mobile,
        );
    }
  }
}

// ============================================================================
// PROJECTS CONTENT
// ============================================================================

class _ProjectsContent
    extends StatelessWidget {
  final bool mobile;

  const _ProjectsContent({
    super.key,
    required this.mobile,
  });

  static const Color card =
      Color(0xFF191919);

  static const Color border =
      Color(0xFF363636);

  static const Color muted =
      Color(0xFF999999);

  static const Color pink =
      Color(0xFFFF4FA3);

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<
        QuerySnapshot<
            Map<String,
                dynamic>>>(
      stream: FirebaseFirestore
          .instance
          .collection(
            'projects',
          )
          .snapshots(),

      builder: (
        context,
        snapshot,
      ) {
        if (snapshot
                .connectionState ==
            ConnectionState
                .waiting) {
          return const SizedBox(
            height: 260,

            child: Center(
              child:
                  CircularProgressIndicator(
                color: pink,
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (snapshot
            .hasError) {
          return _message(
            'Gagal memuat proyek.',
          );
        }

        final docs =
            snapshot.data?.docs ??
                [];

        if (docs.isEmpty) {
          return _message(
            'Belum ada proyek.',
          );
        }

        return LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final int columns =
                mobile
                    ? 1
                    : constraints
                                .maxWidth >=
                            1100
                        ? 3
                        : 2;

            const double gap = 20;

            final double cardWidth =
                columns == 1
                    ? constraints
                        .maxWidth
                    : (constraints
                                .maxWidth -
                            ((columns -
                                    1) *
                                gap)) /
                        columns;

            return Wrap(
              spacing:
                  gap,

              runSpacing:
                  gap,

              children:
                  List.generate(
                docs.length,
                (
                  index,
                ) {
                  return SizedBox(
                    width:
                        cardWidth,

                    child:
                        _ProjectCard(
                      data:
                          docs[index]
                              .data(),

                      mobile:
                          mobile,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _message(
    String text,
  ) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        35,
      ),

      decoration:
          BoxDecoration(
        color:
            card,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              border,
        ),
      ),

      child: Text(
        text,

        style:
            GoogleFonts.dmSans(
          color:
              muted,

          fontSize:
              13,
        ),
      ),
    );
  }
}

// ============================================================================
// KARTU PROJECT
// ============================================================================

class _ProjectCard
    extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool mobile;

  const _ProjectCard({
    required this.data,
    required this.mobile,
  });

  @override
  State<_ProjectCard> createState() =>
      _ProjectCardState();
}

class _ProjectCardState
    extends State<_ProjectCard> {
  bool hovering = false;

  static const Color card =
      Color(0xFF191919);

  static const Color hoverCard =
      Color(0xFF202020);

  static const Color border =
      Color(0xFF383838);

  static const Color white =
      Color(0xFFF5F5F5);

  static const Color muted =
      Color(0xFF999999);

  static const Color pink =
      Color(0xFFFF4FA3);

  // ==========================================================================
  // IMAGES
  // ==========================================================================

  List<String> _getImages() {
    final List<String> images =
        [];

    final String cover =
        widget.data['imageUrl']
                ?.toString()
                .trim() ??
            '';

    if (cover.isNotEmpty) {
      images.add(
        cover,
      );
    }

    final dynamic gallery =
        widget.data['imageUrls'];

    if (gallery is List) {
      for (final dynamic item
          in gallery) {
        final String url =
            item
                .toString()
                .trim();

        if (url.isNotEmpty &&
            !images.contains(
              url,
            )) {
          images.add(
            url,
          );
        }
      }
    }

    return images;
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final String title =
        widget.data['title']
                ?.toString()
                .trim() ??
            'Proyek';

    final String description =
        widget.data['description']
                ?.toString()
                .trim() ??
            '';

    final String category =
        widget.data['category']
                ?.toString()
                .trim() ??
            '';

    final String technology =
        widget.data['technology']
                ?.toString()
                .trim() ??
            '';

    final String projectUrl =
        widget.data['projectUrl']
                ?.toString()
                .trim() ??
            '';

    final List<String> images =
        _getImages();

    final bool hasGallery =
        images.length >
            1;

    return MouseRegion(
      onEnter: (_) {
        if (!widget.mobile) {
          setState(
            () {
              hovering = true;
            },
          );
        }
      },

      onExit: (_) {
        if (!widget.mobile) {
          setState(
            () {
              hovering = false;
            },
          );
        }
      },

      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),

        curve:
            Curves.easeOutCubic,

        transform:
            Matrix4
                .translationValues(
          0,
          hovering
              ? -4
              : 0,
          0,
        ),

        decoration:
            BoxDecoration(
          color:
              hovering
                  ? hoverCard
                  : card,

          borderRadius:
              BorderRadius.circular(
            22,
          ),

          border:
              Border.all(
            color: hovering
                ? pink.withValues(
                    alpha: .45,
                  )
                : border,
          ),

          boxShadow: [
            BoxShadow(
              color:
                  Colors.black
                      .withValues(
                alpha: .20,
              ),

              blurRadius:
                  hovering
                      ? 30
                      : 20,

              offset:
                  const Offset(
                0,
                12,
              ),
            ),
          ],
        ),

        clipBehavior:
            Clip.antiAlias,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [
            // ================================================================
            // IMAGE
            // ================================================================

            GestureDetector(
              onTap:
                  images.isEmpty
                      ? null
                      : () {
                          _openGallery(
                            context,
                            images,
                            title,
                          );
                        },

              child:
                  SizedBox(
                height:
                    widget.mobile
                        ? 205
                        : 220,

                width:
                    double.infinity,

                child: images.isEmpty
                    ? Container(
                        color:
                            const Color(
                          0xFF242424,
                        ),

                        child:
                            const Icon(
                          Icons
                              .image_outlined,

                          color:
                              muted,

                          size:
                              42,
                        ),
                      )
                    : Stack(
                        fit:
                            StackFit.expand,

                        children: [
                          Image.network(
                            images.first,

                            fit:
                                BoxFit.cover,

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                color:
                                    const Color(
                                  0xFF242424,
                                ),

                                child:
                                    const Icon(
                                  Icons
                                      .broken_image_outlined,

                                  color:
                                      muted,

                                  size:
                                      42,
                                ),
                              );
                            },
                          ),

                          if (hasGallery)
                            Positioned(
                              top:
                                  14,
                              right:
                                  14,

                              child:
                                  _GalleryBadge(
                                count:
                                    images.length,
                              ),
                            ),

                          if (hasGallery)
                            const Positioned(
                              left:
                                  14,
                              bottom:
                                  14,

                              child:
                                  _ViewGalleryBadge(),
                            ),
                        ],
                      ),
              ),
            ),

            // ================================================================
            // INFO
            // ================================================================

            Padding(
              padding:
                  const EdgeInsets
                      .fromLTRB(
                22,
                18,
                22,
                20,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  // ==========================================================
                  // CATEGORY
                  // ==========================================================

                  if (category.isNotEmpty)
                    Text(
                      category
                          .toUpperCase(),

                      maxLines:
                          1,

                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          GoogleFonts
                              .dmSans(
                        color:
                            pink,

                        fontSize:
                            8,

                        fontWeight:
                            FontWeight
                                .w800,

                        letterSpacing:
                            1.8,
                      ),
                    ),

                  const SizedBox(
                    height: 8,
                  ),

                  // ==========================================================
                  // TITLE
                  // ==========================================================

                  Text(
                    title,

                    maxLines:
                        2,

                    overflow:
                        TextOverflow
                            .ellipsis,

                    style:
                        GoogleFonts
                            .dmSans(
                      color:
                          white,

                      fontSize:
                          widget.mobile
                              ? 20
                              : 22,

                      fontWeight:
                          FontWeight
                              .w800,

                      height:
                          1.12,

                      letterSpacing:
                          -.6,
                    ),
                  ),

                  // ==========================================================
                  // PREVIEW DESCRIPTION
                  // ==========================================================

                  if (description
                      .isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        top: 10,
                      ),

                      child: Text(
                        description,

                        maxLines:
                            3,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            GoogleFonts
                                .dmSans(
                          color:
                              muted,

                          fontSize:
                              12,

                          height:
                              1.55,
                        ),
                      ),
                    ),

                  const SizedBox(
                    height: 18,
                  ),

                  // ==========================================================
                  // BOTTOM ACTION
                  // ==========================================================

                  Row(
                    children: [
                      Expanded(
                        child:
                            Text(
                          projectUrl
                                  .isEmpty
                              ? 'Belum ada tautan'
                              : 'Tautan proyek',

                          maxLines:
                              1,

                          overflow:
                              TextOverflow
                                  .ellipsis,

                          style:
                              GoogleFonts
                                  .dmSans(
                            color:
                                muted,

                            fontSize:
                                11,

                            fontWeight:
                                FontWeight
                                    .w600,
                          ),
                        ),
                      ),

                      // ======================================================
                      // DETAIL
                      // ======================================================

                      _DetailsButton(
                        onTap: () {
                          _showProjectDetail(
                            context,

                            title:
                                title,

                            category:
                                category,

                            technology:
                                technology,

                            description:
                                description,

                            projectUrl:
                                projectUrl,

                            images:
                                images,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // PROJECT DETAIL
  // ==========================================================================

  Future<void>
      _showProjectDetail(
    BuildContext context, {
    required String title,
    required String category,
    required String technology,
    required String description,
    required String projectUrl,
    required List<String> images,
  }) async {
    await showDialog<void>(
      context:
          context,

      barrierDismissible:
          true,

      barrierColor:
          Colors.black
              .withValues(
        alpha: .80,
      ),

      builder:
          (dialogContext) {
        return Dialog(
          backgroundColor:
              Colors.transparent,

          insetPadding:
              EdgeInsets.symmetric(
            horizontal:
                widget.mobile
                    ? 14
                    : 30,

            vertical:
                widget.mobile
                    ? 18
                    : 30,
          ),

          child:
              _ProjectDetailDialog(
            title:
                title,

            category:
                category,

            technology:
                technology,

            description:
                description,

            projectUrl:
                projectUrl,

            images:
                images,

            mobile:
                widget.mobile,
          ),
        );
      },
    );
  }

  // ==========================================================================
  // GALLERY
  // ==========================================================================

  Future<void> _openGallery(
    BuildContext context,
    List<String> images,
    String title,
  ) async {
    int current = 0;

    await showDialog<void>(
      context:
          context,

      barrierColor:
          Colors.black
              .withValues(
        alpha: .90,
      ),

      builder:
          (dialogContext) {
        return StatefulBuilder(
          builder:
              (
            context,
            setDialogState,
          ) {
            return Dialog(
              backgroundColor:
                  Colors.transparent,

              insetPadding:
                  const EdgeInsets
                      .all(
                20,
              ),

              child:
                  Container(
                constraints:
                    const BoxConstraints(
                  maxWidth:
                      1100,
                  maxHeight:
                      760,
                ),

                padding:
                    const EdgeInsets
                        .all(
                  16,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFF151515,
                  ),

                  borderRadius:
                      BorderRadius
                          .circular(
                    22,
                  ),

                  border:
                      Border.all(
                    color: Colors
                        .white
                        .withValues(
                      alpha: .10,
                    ),
                  ),
                ),

                child:
                    Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child:
                              Text(
                            title,

                            maxLines:
                                1,

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                GoogleFonts
                                    .dmSans(
                              color:
                                  white,

                              fontSize:
                                  16,

                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed:
                              () {
                            Navigator.pop(
                              dialogContext,
                            );
                          },

                          icon:
                              const Icon(
                            Icons
                                .close_rounded,

                            color:
                                white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Expanded(
                      child:
                          Image.network(
                        images[
                            current],

                        fit:
                            BoxFit.contain,

                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Icon(
                            Icons
                                .broken_image_outlined,

                            color:
                                muted,

                            size:
                                50,
                          );
                        },
                      ),
                    ),

                    if (images
                            .length >
                        1)
                      Padding(
                        padding:
                            const EdgeInsets
                                .only(
                          top: 14,
                        ),

                        child:
                            Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                          children: [
                            IconButton(
                              onPressed:
                                  current >
                                          0
                                      ? () {
                                          setDialogState(
                                            () {
                                              current--;
                                            },
                                          );
                                        }
                                      : null,

                              icon:
                                  const Icon(
                                Icons
                                    .arrow_back_ios_new_rounded,

                                color:
                                    white,
                              ),
                            ),

                            Text(
                              '${current + 1} / ${images.length}',

                              style:
                                  GoogleFonts
                                      .dmSans(
                                color:
                                    muted,

                                fontSize:
                                    11,
                              ),
                            ),

                            IconButton(
                              onPressed:
                                  current <
                                          images.length -
                                              1
                                      ? () {
                                          setDialogState(
                                            () {
                                              current++;
                                            },
                                          );
                                        }
                                      : null,

                              icon:
                                  const Icon(
                                Icons
                                    .arrow_forward_ios_rounded,

                                color:
                                    white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ============================================================================
// PROJECT DETAIL DIALOG
// ============================================================================

class _ProjectDetailDialog
    extends StatefulWidget {
  final String title;
  final String category;
  final String technology;
  final String description;
  final String projectUrl;
  final List<String> images;
  final bool mobile;

  const _ProjectDetailDialog({
    required this.title,
    required this.category,
    required this.technology,
    required this.description,
    required this.projectUrl,
    required this.images,
    required this.mobile,
  });

  @override
  State<
      _ProjectDetailDialog>
      createState() =>
          _ProjectDetailDialogState();
}

class _ProjectDetailDialogState
    extends State<_ProjectDetailDialog> {
  bool hovering = false;

  static const Color background =
      Color(0xFF151515);

  static const Color card =
      Color(0xFF1D1D1D);

  static const Color white =
      Color(0xFFF5F5F5);

  static const Color muted =
      Color(0xFF999999);

  static const Color pink =
      Color(0xFFFF4FA3);

  static const Color border =
      Color(0xFF383838);

  Future<void> _openUrl() async {
    String url =
        widget.projectUrl.trim();

    if (url.isEmpty) {
      return;
    }

    if (!url.startsWith('http://') &&
        !url.startsWith('https://')) {
      url = 'https://$url';
    }

    final Uri? uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        widget.images.isNotEmpty;

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 980,
        maxHeight: 760,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .48,
            ),
            blurRadius: 55,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ================================================================
          // HEADER
          // ================================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              20,
              18,
              16,
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      if (widget.category
                          .isNotEmpty)
                        Text(
                          widget.category
                              .toUpperCase(),
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              GoogleFonts.dmSans(
                            color: pink,
                            fontSize: 8,
                            fontWeight:
                                FontWeight.w800,
                            letterSpacing: 2,
                          ),
                        ),
                      const SizedBox(height: 7),
                      Text(
                        widget.title,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            GoogleFonts.dmSans(
                          color: white,
                          fontSize:
                              widget.mobile
                                  ? 23
                                  : 30,
                          fontWeight:
                              FontWeight.w800,
                          height: 1.08,
                          letterSpacing: -.8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Tutup',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // ================================================================
          // BODY
          // ================================================================

          Expanded(
            child: SingleChildScrollView(
              physics:
                  const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                24,
                2,
                24,
                widget.mobile ? 24 : 28,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ========================================================
                  // DESKTOP: IMAGE + SUMMARY SIDE BY SIDE
                  // MOBILE: IMAGE THEN TEXT
                  // ========================================================

                  if (widget.mobile)
                    _buildMobileTop(hasImage)
                  else
                    _buildDesktopTop(hasImage),

                  // ========================================================
                  // TECHNOLOGY
                  // ========================================================

                  if (widget.technology
                      .isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildTechnology(),
                  ],

                  // ========================================================
                  // PROJECT LINK
                  // ========================================================

                  if (widget.projectUrl
                      .isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _buildProjectLink(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTop(bool hasImage) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        if (hasImage)
          Expanded(
            flex: 46,
            child: _buildCover(
              height: 245,
            ),
          ),
        if (hasImage)
          const SizedBox(width: 22),
        Expanded(
          flex: 54,
          child: _buildDescription(),
        ),
      ],
    );
  }

  Widget _buildMobileTop(bool hasImage) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        if (hasImage) ...[
          _buildCover(height: 200),
          const SizedBox(height: 22),
        ],
        _buildDescription(),
      ],
    );
  }

  Widget _buildCover({
    required double height,
  }) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(18),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.network(
          widget.images.first,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: card,
              child: const Center(
                child: Icon(
                  Icons
                      .broken_image_outlined,
                  color: muted,
                  size: 40,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'TENTANG PROJECT',
          style: GoogleFonts.dmSans(
            color: muted,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.description.isNotEmpty
              ? widget.description
              : 'Belum ada deskripsi project.',
          style: GoogleFonts.dmSans(
            color: white.withValues(
              alpha: .90,
            ),
            fontSize:
                widget.mobile ? 13 : 14,
            height: 1.72,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildTechnology() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: card,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'TECHNOLOGY',
            style: GoogleFonts.dmSans(
              color: pink,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            widget.technology,
            style: GoogleFonts.dmSans(
              color: white,
              fontSize:
                  widget.mobile ? 12 : 13,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectLink() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'PROJECT LINK',
          style: GoogleFonts.dmSans(
            color: muted,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 9),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: card,
            borderRadius:
                BorderRadius.circular(16),
            border: Border.all(
              color: border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: pink.withValues(
                    alpha: .10,
                  ),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.link_rounded,
                  color: pink,
                  size: 17,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.projectUrl,
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      GoogleFonts.dmSans(
                    color: muted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        MouseRegion(
          cursor:
              SystemMouseCursors.click,
          onEnter: (_) {
            setState(() {
              hovering = true;
            });
          },
          onExit: (_) {
            setState(() {
              hovering = false;
            });
          },
          child: GestureDetector(
            onTap: _openUrl,
            child: AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 170,
              ),
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: hovering
                    ? pink
                    : const Color(0xFF303030),
                borderRadius:
                    BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    'Buka Tautan Proyek',
                    style:
                        GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Icon(
                    Icons
                        .arrow_outward_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
// GALLERY BADGE
// ============================================================================

class _GalleryBadge
    extends StatelessWidget {
  final int count;

  const _GalleryBadge({
    required this.count,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 11,
        vertical: 7,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.black
                .withValues(
          alpha: .68,
        ),

        borderRadius:
            BorderRadius.circular(
          100,
        ),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          const Icon(
            Icons
                .photo_library_outlined,

            color:
                Colors.white,

            size:
                13,
          ),

          const SizedBox(
            width: 6,
          ),

          Text(
            '$count foto',

            style:
                GoogleFonts.dmSans(
              color:
                  Colors.white,

              fontSize:
                  9,

              fontWeight:
                  FontWeight
                      .w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// VIEW GALLERY BADGE
// ============================================================================

class _ViewGalleryBadge
    extends StatelessWidget {
  const _ViewGalleryBadge();

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration:
          BoxDecoration(
        color:
            Colors.black
                .withValues(
          alpha: .68,
        ),

        borderRadius:
            BorderRadius.circular(
          100,
        ),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [
          const Icon(
            Icons
                .collections_outlined,

            color:
                Colors.white,

            size:
                14,
          ),

          const SizedBox(
            width: 7,
          ),

          Text(
            'Lihat Galeri',

            style:
                GoogleFonts.dmSans(
              color:
                  Colors.white,

              fontSize:
                  10,

              fontWeight:
                  FontWeight
                      .w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// DETAIL BUTTON
// ============================================================================

class _DetailsButton
    extends StatefulWidget {
  final VoidCallback onTap;

  const _DetailsButton({
    required this.onTap,
  });

  @override
  State<_DetailsButton>
      createState() =>
          _DetailsButtonState();
}

class _DetailsButtonState
    extends State<
        _DetailsButton> {
  bool hovering = false;

  @override
  Widget build(
    BuildContext context,
  ) {
    return MouseRegion(
      cursor:
          SystemMouseCursors
              .click,

      onEnter: (_) {
        setState(
          () {
            hovering = true;
          },
        );
      },

      onExit: (_) {
        setState(
          () {
            hovering = false;
          },
        );
      },

      child:
          GestureDetector(
        onTap:
            widget.onTap,

        child:
            AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 170,
          ),

          padding:
              const EdgeInsets
                  .symmetric(
            horizontal: 17,
            vertical: 11,
          ),

          decoration:
              BoxDecoration(
            color: hovering
                ? const Color(
                    0xFF444444,
                  )
                : const Color(
                    0xFF303030,
                  ),

            borderRadius:
                BorderRadius.circular(
              100,
            ),
          ),

          child: Row(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              Text(
                'Detail',

                style:
                    GoogleFonts.dmSans(
                  color:
                      Colors.white,

                  fontSize:
                      11,

                  fontWeight:
                      FontWeight
                          .w600,
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              const Icon(
                Icons
                    .arrow_forward_rounded,

                color:
                    Colors.white,

                size:
                    15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SERTIFIKAT
// ============================================================================

class _CertificatesContent
    extends StatelessWidget {
  final bool mobile;

  const _CertificatesContent({
    super.key,
    required this.mobile,
  });

  static const List<
      Map<String, String>>
      certificates = [
    {
      'title':
          'Junior Cyber Security',
      'issuer':
          'BPSDMP Surabaya • 2025',
      'image':
          'assets/images/cyber.jpg',
    },
    {
      'title':
          'English Proficiency Test',
      'issuer':
          'UPA Bahasa Politeknik Negeri Madiun • 2026',
      'image':
          'assets/images/ept.jpg',
    },
    {
      'title':
          'Junior Web Developer',
      'issuer':
          'BPSDMP Surabaya • 2024',
      'image':
          'assets/images/web.jpg',
    },
  ];

  @override
  Widget build(
    BuildContext context,
  ) {
    return LayoutBuilder(
      builder: (
        context,
        constraints,
      ) {
        final int columns =
            mobile
                ? 1
                : constraints
                            .maxWidth >=
                        1000
                    ? 3
                    : 2;

        const double gap = 20;

        final double width =
            columns == 1
                ? constraints.maxWidth
                : (constraints
                            .maxWidth -
                        ((columns -
                                1) *
                            gap)) /
                    columns;

        return Wrap(
          spacing:
              gap,

          runSpacing:
              gap,

          children:
              List.generate(
            certificates.length,
            (index) {
              final Map<
                      String,
                      String>
                  certificate =
                  certificates[
                      index];

              return SizedBox(
                width:
                    width,

                child:
                    _CertificateCard(
                  title:
                      certificate[
                          'title']!,

                  issuer:
                      certificate[
                          'issuer']!,

                  imagePath:
                      certificate[
                          'image']!,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ============================================================================
// CERTIFICATE CARD
// ============================================================================

class _CertificateCard
    extends StatefulWidget {
  final String title;
  final String issuer;
  final String imagePath;

  const _CertificateCard({
    required this.title,
    required this.issuer,
    required this.imagePath,
  });

  @override
  State<
      _CertificateCard>
      createState() =>
          _CertificateCardState();
}

class _CertificateCardState
    extends State<
        _CertificateCard> {
  bool hovering = false;

  static const Color card =
      Color(0xFF191919);

  static const Color hoverCard =
      Color(0xFF202020);

  static const Color border =
      Color(0xFF363636);

  static const Color white =
      Color(0xFFF5F5F5);

  static const Color pink =
      Color(0xFFFF4FA3);

  @override
  Widget build(
    BuildContext context,
  ) {
    return MouseRegion(
      cursor:
          SystemMouseCursors
              .click,

      onEnter: (_) {
        setState(
          () {
            hovering = true;
          },
        );
      },

      onExit: (_) {
        setState(
          () {
            hovering = false;
          },
        );
      },

      child:
          GestureDetector(
        onTap: () {
          _showCertificate(
            context,
          );
        },

        child:
            AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 200,
          ),

          curve:
              Curves.easeOutCubic,

          transform:
              Matrix4.translationValues(
            0,
            hovering
                ? -4
                : 0,
            0,
          ),

          decoration:
              BoxDecoration(
            color:
                hovering
                    ? hoverCard
                    : card,

            borderRadius:
                BorderRadius.circular(
              22,
            ),

            border:
                Border.all(
              color: hovering
                  ? pink.withValues(
                      alpha: .45,
                    )
                  : border,
            ),
          ),

          clipBehavior:
              Clip.antiAlias,

          child:
              Column(
            crossAxisAlignment:
                CrossAxisAlignment
                    .start,

            children: [
              AspectRatio(
                aspectRatio:
                    1.48,

                child:
                    Stack(
                  fit:
                      StackFit.expand,

                  children: [
                    Image.asset(
                      widget.imagePath,

                      fit:
                          BoxFit.cover,

                      errorBuilder:
                          (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return Container(
                          color:
                              const Color(
                            0xFF242424,
                          ),

                          child:
                              const Icon(
                            Icons
                                .broken_image_outlined,

                            color:
                                Colors.white54,

                            size:
                                42,
                          ),
                        );
                      },
                    ),

                    AnimatedOpacity(
                      duration:
                          const Duration(
                        milliseconds:
                            180,
                      ),

                      opacity:
                          hovering
                              ? 1
                              : 0,

                      child:
                          Container(
                        color:
                            Colors.black
                                .withValues(
                          alpha:
                              .30,
                        ),

                        child:
                            const Center(
                          child:
                              Icon(
                            Icons
                                .zoom_in_rounded,

                            color:
                                white,

                            size:
                                36,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets
                        .fromLTRB(
                  20,
                  17,
                  20,
                  20,
                ),

                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      widget.title,

                      maxLines:
                          2,

                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          GoogleFonts
                              .dmSans(
                        color:
                            white,

                        fontSize:
                            17,

                        fontWeight:
                            FontWeight
                                .w800,

                        height:
                            1.15,
                      ),
                    ),

                    const SizedBox(
                      height: 7,
                    ),

                    Text(
                      widget.issuer,

                      maxLines:
                          2,

                      overflow:
                          TextOverflow
                              .ellipsis,

                      style:
                          GoogleFonts
                              .dmSans(
                        color:
                            pink,

                        fontSize:
                            9,

                        fontWeight:
                            FontWeight
                                .w800,

                        letterSpacing:
                            1.1,

                        height:
                            1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // SHOW CERTIFICATE
  // ==========================================================================

  void _showCertificate(
    BuildContext context,
  ) {
    showDialog<void>(
      context:
          context,

      barrierColor:
          Colors.black
              .withValues(
        alpha: .92,
      ),

      builder:
          (context) {
        return Dialog(
          backgroundColor:
              Colors.transparent,

          insetPadding:
              const EdgeInsets
                  .all(
            20,
          ),

          child:
              Stack(
            children: [
              Center(
                child:
                    Container(
                  constraints:
                      const BoxConstraints(
                    maxWidth:
                        1100,

                    maxHeight:
                        800,
                  ),

                  padding:
                      const EdgeInsets
                          .all(
                    10,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        const Color(
                      0xFF151515,
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),

                    border:
                        Border.all(
                      color: Colors
                          .white
                          .withValues(
                        alpha:
                            .10,
                      ),
                    ),
                  ),

                  child:
                      ClipRRect(
                    borderRadius:
                        BorderRadius
                            .circular(
                      14,
                    ),

                    child:
                        Image.asset(
                      widget
                          .imagePath,

                      fit:
                          BoxFit
                              .contain,
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 0,
                right: 0,

                child:
                    IconButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  icon:
                      const Icon(
                    Icons
                        .close_rounded,

                    color:
                        Colors.white,

                    size:
                        26,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ============================================================================
// SKILLS
// ============================================================================

class _SkillsContent
    extends StatelessWidget {
  final bool mobile;

  const _SkillsContent({
    super.key,
    required this.mobile,
  });

  static const Color card =
      Color(0xFF191919);

  static const Color border =
      Color(0xFF363636);

  static const Color muted =
      Color(0xFF999999);

  static const Color pink =
      Color(0xFFFF4FA3);

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<
        QuerySnapshot<
            Map<String,
                dynamic>>>(
      stream: FirebaseFirestore
          .instance
          .collection(
            'skills',
          )
          .orderBy(
            'createdAt',
            descending:
                true,
          )
          .snapshots(),

      builder: (
        context,
        snapshot,
      ) {
        if (snapshot
                .connectionState ==
            ConnectionState
                .waiting) {
          return const SizedBox(
            height: 240,

            child: Center(
              child:
                  CircularProgressIndicator(
                color: pink,
                strokeWidth: 2,
              ),
            ),
          );
        }

        if (snapshot
            .hasError) {
          return _message(
            'Gagal memuat keahlian.',
          );
        }

        final docs =
            snapshot.data?.docs ??
                [];

        if (docs.isEmpty) {
          return _message(
            'Belum ada keahlian.',
          );
        }

        return LayoutBuilder(
          builder: (
            context,
            constraints,
          ) {
            final int columns =
                mobile
                    ? 1
                    : constraints
                                .maxWidth >=
                            1050
                        ? 3
                        : 2;

            const double gap = 14;

            final double width =
                columns == 1
                    ? constraints
                        .maxWidth
                    : (constraints
                                .maxWidth -
                            ((columns -
                                    1) *
                                gap)) /
                        columns;

            return Wrap(
              spacing:
                  gap,

              runSpacing:
                  gap,

              children:
                  List.generate(
                docs.length,
                (index) {
                  return SizedBox(
                    width:
                        width,

                    child:
                        _SkillCard(
                      data:
                          docs[index]
                              .data(),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _message(
    String text,
  ) {
    return Container(
      width:
          double.infinity,

      padding:
          const EdgeInsets.all(
        35,
      ),

      decoration:
          BoxDecoration(
        color:
            card,

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              border,
        ),
      ),

      child:
          Text(
        text,

        style:
            GoogleFonts.dmSans(
          color:
              muted,

          fontSize:
              13,
        ),
      ),
    );
  }
}

// ============================================================================
// SKILL CARD
// ============================================================================

class _SkillCard
    extends StatefulWidget {
  final Map<String, dynamic> data;

  const _SkillCard({
    required this.data,
  });

  @override
  State<_SkillCard> createState() =>
      _SkillCardState();
}

class _SkillCardState
    extends State<
        _SkillCard> {
  bool hovering = false;

  static const Color card =
      Color(0xFF191919);

  static const Color hoverCard =
      Color(0xFF202020);

  static const Color border =
      Color(0xFF363636);

  static const Color white =
      Color(0xFFF5F5F5);

  static const Color muted =
      Color(0xFF999999);

  static const Color pink =
      Color(0xFFFF4FA3);

  // ==========================================================================
  // DEVICON
  // ==========================================================================

  String? _logoUrl(
    String value,
  ) {
    final String skill =
        value
            .trim()
            .toLowerCase()
            .replaceAll(
              '.',
              '',
            )
            .replaceAll(
              '-',
              ' ',
            )
            .replaceAll(
              '_',
              ' ',
            );

    const Map<String, String>
        logos = {
      'flutter':
          'flutter',

      'dart':
          'dart',

      'firebase':
          'firebase',

      'html':
          'html5',

      'html5':
          'html5',

      'css':
          'css3',

      'css3':
          'css3',

      'javascript':
          'javascript',

      'js':
          'javascript',

      'typescript':
          'typescript',

      'ts':
          'typescript',

      'react':
          'react',

      'reactjs':
          'react',

      'nextjs':
          'nextjs',

      'next js':
          'nextjs',

      'next':
          'nextjs',

      'vue':
          'vuejs',

      'vuejs':
          'vuejs',

      'angular':
          'angular',

      'bootstrap':
          'bootstrap',

      'tailwind':
          'tailwindcss',

      'tailwind css':
          'tailwindcss',

      'laravel':
          'laravel',

      'php':
          'php',

      'nodejs':
          'nodejs',

      'node js':
          'nodejs',

      'node':
          'nodejs',

      'mysql':
          'mysql',

      'postgresql':
          'postgresql',

      'postgres':
          'postgresql',

      'mongodb':
          'mongodb',

      'sqlite':
          'sqlite',

      'python':
          'python',

      'java':
          'java',

      'kotlin':
          'kotlin',

      'c++':
          'cplusplus',

      'cpp':
          'cplusplus',

      'c#':
          'csharp',

      'csharp':
          'csharp',

      'go':
          'go',

      'rust':
          'rust',

      'git':
          'git',

      'github':
          'github',

      'gitlab':
          'gitlab',

      'visual studio code':
          'vscode',

      'vs code':
          'vscode',

      'vscode':
          'vscode',

      'android studio':
          'androidstudio',

      'figma':
          'figma',

      'postman':
          'postman',

      'unreal engine':
          'unrealengine',

      'unreal':
          'unrealengine',

      'unity':
          'unity',

      'blender':
          'blender',

      'canva':
          'canva',

      'photoshop':
          'photoshop',

      'adobe photoshop':
          'photoshop',

      'illustrator':
          'illustrator',

      'adobe illustrator':
          'illustrator',
    };

    final String? icon =
        logos[skill];

    if (icon == null) {
      return null;
    }

    return 'https://cdn.jsdelivr.net/gh/devicons/devicon@v2.17.0/icons/$icon/$icon-original.svg';
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final String name =
        widget.data['name']
                ?.toString()
                .trim() ??
            'Keahlian';

    final String category =
        widget.data['category']
                ?.toString()
                .trim() ??
            '';

    int level = 0;

    final dynamic
        rawLevel =
        widget.data['level'];

    if (rawLevel is int) {
      level =
          rawLevel;
    } else if (rawLevel
        is double) {
      level =
          rawLevel.round();
    } else {
      level =
          int.tryParse(
                rawLevel
                        ?.toString() ??
                    '',
              ) ??
              0;
    }

    level =
        level.clamp(
      0,
      100,
    );

    final String?
        logoUrl =
        _logoUrl(
      name,
    );

    return MouseRegion(
      onEnter: (_) {
        setState(
          () {
            hovering = true;
          },
        );
      },

      onExit: (_) {
        setState(
          () {
            hovering = false;
          },
        );
      },

      child:
          AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 180,
        ),

        curve:
            Curves.easeOutCubic,

        transform:
            Matrix4
                .translationValues(
          0,
          hovering
              ? -3
              : 0,
          0,
        ),

        padding:
            const EdgeInsets
                .all(
          16,
        ),

        decoration:
            BoxDecoration(
          color:
              hovering
                  ? hoverCard
                  : card,

          borderRadius:
              BorderRadius.circular(
            18,
          ),

          border:
              Border.all(
            color: hovering
                ? pink.withValues(
                    alpha: .40,
                  )
                : border,
          ),
        ),

        child:
            Row(
          children: [
            // ================================================================
            // ICON
            // ================================================================

            Container(
              width:
                  46,

              height:
                  46,

              alignment:
                  Alignment.center,

              decoration:
                  BoxDecoration(
                color:
                    pink.withValues(
                  alpha:
                      .10,
                ),

                borderRadius:
                    BorderRadius
                        .circular(
                  13,
                ),
              ),

              child: logoUrl ==
                      null
                  ? Text(
                      name.isEmpty
                          ? '?'
                          : name
                              .substring(
                              0,
                              1,
                            )
                              .toUpperCase(),

                      style:
                          GoogleFonts
                              .dmSans(
                        color:
                            pink,

                        fontSize:
                            15,

                        fontWeight:
                            FontWeight
                                .w800,
                      ),
                    )
                  : SvgPicture.network(
                      logoUrl,

                      width:
                          26,

                      height:
                          26,

                      fit:
                          BoxFit.contain,

                      placeholderBuilder:
                          (
                        context,
                      ) {
                        return Text(
                          name
                              .isEmpty
                              ? '?'
                              : name
                                  .substring(
                                  0,
                                  1,
                                )
                                  .toUpperCase(),

                          style:
                              GoogleFonts
                                  .dmSans(
                            color:
                                pink,

                            fontSize:
                                14,

                            fontWeight:
                                FontWeight
                                    .w800,
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(
              width: 13,
            ),

            // ================================================================
            // NAME
            // ================================================================

            Expanded(
              child:
                  Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [
                  Text(
                    name,

                    maxLines:
                        1,

                    overflow:
                        TextOverflow
                            .ellipsis,

                    style:
                        GoogleFonts
                            .dmSans(
                      color:
                          white,

                      fontSize:
                          13,

                      fontWeight:
                          FontWeight
                              .w700,
                    ),
                  ),

                  if (category
                      .isNotEmpty)
                    Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        top: 3,
                      ),

                      child:
                          Text(
                        category,

                        maxLines:
                            1,

                        overflow:
                            TextOverflow
                                .ellipsis,

                        style:
                            GoogleFonts
                                .dmSans(
                          color:
                              muted,

                          fontSize:
                              9,
                        ),
                      ),
                    ),

                  // ==========================================================
                  // LEVEL
                  // ==========================================================

                  if (level > 0)
                    Padding(
                      padding:
                          const EdgeInsets
                              .only(
                        top: 8,
                      ),

                      child:
                          Row(
                        children:
                            List.generate(
                          5,
                          (
                            index,
                          ) {
                            final int
                                threshold =
                                (index +
                                        1) *
                                    20;

                            return Container(
                              width:
                                  16,

                              height:
                                  3,

                              margin:
                                  const EdgeInsets
                                      .only(
                                right:
                                    3,
                              ),

                              decoration:
                                  BoxDecoration(
                                color:
                                    level >=
                                            threshold
                                        ? pink
                                        : white
                                            .withValues(
                                            alpha:
                                                .08,
                                          ),

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  100,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            AnimatedOpacity(
              duration:
                  const Duration(
                milliseconds:
                    150,
              ),

              opacity:
                  hovering
                      ? 1
                      : .25,

              child:
                  const Icon(
                Icons
                    .arrow_outward_rounded,

                color:
                    pink,

                size:
                    15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
