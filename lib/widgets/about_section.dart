import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../pages/cv_viewer_page.dart';

// ============================================================
// COLORS
// ============================================================

const Color kAboutBackground = Color(0xFF09080F);
const Color kAboutSurface = Color(0xFF15111D);
const Color kAboutSurfaceLight = Color(0xFF1D1727);
const Color kAboutBorder = Color(0xFF30263A);

const Color kAboutWhite = Color(0xFFF7F2FF);
const Color kAboutMuted = Color(0xAAAFA7BA);

const Color kAboutPink = Color(0xFFFF4FA3);
const Color kAboutPinkSoft = Color(0xFFFF77B7);

// ============================================================
// ABOUT SECTION
// ============================================================

class AboutSection extends StatefulWidget {
  const AboutSection({
    super.key,
  });

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;

  late final Animation<double> _photoOpacity;
  late final Animation<Offset> _photoSlide;

  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentSlide;

  late final Animation<double> _buttonOpacity;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1100,
      ),
    );

    // ========================================================
    // PHOTO ANIMATION
    // ========================================================

    _photoOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.0,
        0.50,
        curve: Curves.easeOut,
      ),
    );

    _photoSlide = Tween<Offset>(
      begin: const Offset(
        -0.12,
        0.05,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.0,
          0.60,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ========================================================
    // CONTENT ANIMATION
    // ========================================================

    _contentOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.15,
        0.70,
        curve: Curves.easeOut,
      ),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(
        0.10,
        0.04,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.15,
          0.72,
          curve: Curves.easeOutCubic,
        ),
      ),
    );

    // ========================================================
    // BUTTON ANIMATION
    // ========================================================

    _buttonOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(
        0.50,
        1.0,
        curve: Curves.easeOut,
      ),
    );

    _buttonSlide = Tween<Offset>(
      begin: const Offset(
        0,
        0.15,
      ),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(
          0.50,
          1.0,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    Future<void>.delayed(
      const Duration(
        milliseconds: 120,
      ),
      () {
        if (mounted) {
          _entranceController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return StreamBuilder<
        DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('profile')
          .doc('main')
          .snapshots(),
      builder: (
        context,
        snapshot,
      ) {
        final Map<String, dynamic>? data =
            snapshot.data?.data();

        // ======================================================
        // FIREBASE DATA
        // ======================================================

        final String aboutDescription =
            data?['aboutDescription']
                        ?.toString()
                        .trim()
                        .isNotEmpty ==
                    true
                ? data!['aboutDescription']
                    .toString()
                    .trim()
                : 'Lulusan D3 Teknologi Informasi yang memiliki ketertarikan pada software engineering dan pengembangan aplikasi. Senang mengubah ide menjadi solusi digital yang fungsional, efisien, dan terus berkembang.';

        final String location =
            data?['location']
                        ?.toString()
                        .trim()
                        .isNotEmpty ==
                    true
                ? data!['location']
                    .toString()
                    .trim()
                : 'Madiun, Jawa Timur, Indonesia';

        final String status =
            data?['status']
                        ?.toString()
                        .trim()
                        .isNotEmpty ==
                    true
                ? data!['status']
                    .toString()
                    .trim()
                : 'Terbuka untuk peluang kerja';

        return Container(
          width: double.infinity,
          color: kAboutBackground,
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 22,
          ),
          child: LayoutBuilder(
            builder: (
              context,
              constraints,
            ) {
              final bool mobile =
                  constraints.maxWidth < 960;

              return Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1220,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(
                      mobile ? 22 : 36,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          kAboutSurface.withValues(
                        alpha: 0.92,
                      ),
                      borderRadius:
                          BorderRadius.circular(28),
                      border: Border.all(
                        color: kAboutBorder,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Colors.black.withValues(
                            alpha: 0.35,
                          ),
                          blurRadius: 45,
                          offset:
                              const Offset(
                            0,
                            22,
                          ),
                        ),
                      ],
                    ),
                    child: mobile
                        ? _buildMobile(
                            aboutDescription:
                                aboutDescription,
                            location:
                                location,
                            status:
                                status,
                          )
                        : _buildDesktop(
                            aboutDescription:
                                aboutDescription,
                            location:
                                location,
                            status:
                                status,
                          ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ==========================================================
  // DESKTOP
  // ==========================================================

  Widget _buildDesktop({
    required String aboutDescription,
    required String location,
    required String status,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 38,
          child: FadeTransition(
            opacity: _photoOpacity,
            child: SlideTransition(
              position: _photoSlide,
              child:
                  const _InteractivePhoto(),
            ),
          ),
        ),

        const SizedBox(
          width: 58,
        ),

        Expanded(
          flex: 62,
          child: _buildContent(
            desktop: true,
            aboutDescription:
                aboutDescription,
            location: location,
            status: status,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MOBILE
  // ==========================================================

  Widget _buildMobile({
    required String aboutDescription,
    required String location,
    required String status,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        FadeTransition(
          opacity: _photoOpacity,
          child: SlideTransition(
            position: _photoSlide,
            child:
                const _InteractivePhoto(
              compact: true,
            ),
          ),
        ),

        const SizedBox(
          height: 28,
        ),

        _buildContent(
          desktop: false,
          aboutDescription:
              aboutDescription,
          location: location,
          status: status,
        ),
      ],
    );
  }

  // ==========================================================
  // CONTENT
  // ==========================================================

  Widget _buildContent({
    required bool desktop,
    required String aboutDescription,
    required String location,
    required String status,
  }) {
    return FadeTransition(
      opacity: _contentOpacity,
      child: SlideTransition(
        position: _contentSlide,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // ==================================================
            // SECTION TITLE
            // ==================================================

            Row(
              children: [
                Container(
                  width: 38,
                  height: 3,
                  decoration:
                      BoxDecoration(
                    color: kAboutPink,
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            kAboutPink.withValues(
                          alpha: 0.45,
                        ),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                Text(
                  'ABOUT ME',
                  style:
                      GoogleFonts.spaceMono(
                    color:
                        kAboutPinkSoft,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w700,
                    letterSpacing: 2.2,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 18,
            ),

            // ==================================================
            // HEADING
            // ==================================================

            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Tentang ',
                    style:
                        GoogleFonts.dmSans(
                      color:
                          kAboutWhite,
                      fontSize:
                          desktop ? 40 : 33,
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing:
                          desktop
                              ? -1.8
                              : -1.3,
                    ),
                  ),
                  TextSpan(
                    text: 'Saya',
                    style:
                        GoogleFonts.dmSans(
                      color:
                          kAboutPink,
                      fontSize:
                          desktop ? 40 : 33,
                      fontWeight:
                          FontWeight.w900,
                      letterSpacing:
                          desktop
                              ? -1.8
                              : -1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Software Engineer · Teknologi Informasi',
              style:
                  GoogleFonts.dmSans(
                color: kAboutMuted,
                fontSize:
                    desktop ? 13 : 12,
                fontStyle:
                    FontStyle.italic,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            // ==================================================
            // DESCRIPTION
            // ==================================================

            Text(
              aboutDescription,
              style:
                  GoogleFonts.dmSans(
                color: kAboutMuted,
                fontSize:
                    desktop ? 14 : 13,
                height: 1.75,
              ),
            ),

            const SizedBox(
              height: 26,
            ),

            // ==================================================
            // STATUS + LOCATION
            // ==================================================

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _InfoBadge(
                  icon:
                      Icons.work_outline_rounded,
                  label: 'STATUS',
                  value: status,
                ),

                _InfoBadge(
                  icon:
                      Icons.location_on_outlined,
                  label: 'LOKASI',
                  value: location,
                ),
              ],
            ),

            const SizedBox(
              height: 30,
            ),

            // ==================================================
            // VIEW CV
            // ==================================================

            FadeTransition(
              opacity: _buttonOpacity,
              child: SlideTransition(
                position: _buttonSlide,
                child:
                    const _ViewCvButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INFO BADGE
// ============================================================

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 11,
      ),
      decoration:
          BoxDecoration(
        color:
            kAboutPink.withValues(
          alpha: 0.055,
        ),
        border: Border.all(
          color:
              kAboutPink.withValues(
            alpha: 0.28,
          ),
          width: 1,
        ),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: kAboutPink,
            size: 16,
          ),

          const SizedBox(
            width: 10,
          ),

          Text(
            '$label  ',
            style:
                GoogleFonts.spaceMono(
              color: kAboutPinkSoft,
              fontSize: 8,
              fontWeight:
                  FontWeight.w700,
              letterSpacing: 1,
            ),
          ),

          Flexible(
            child: Text(
              value,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  GoogleFonts.dmSans(
                color: kAboutWhite,
                fontSize: 11,
                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// INTERACTIVE PHOTO
// ============================================================

class _InteractivePhoto
    extends StatefulWidget {
  final bool compact;

  const _InteractivePhoto({
    this.compact = false,
  });

  @override
  State<_InteractivePhoto> createState() =>
      _InteractivePhotoState();
}

class _InteractivePhotoState
    extends State<_InteractivePhoto>
    with SingleTickerProviderStateMixin {
  late final AnimationController
      _swapController;

  bool _isSpiderMan = false;
  bool _hovering = false;

  double _rotationX = 0;
  double _rotationY = 0;

  @override
  void initState() {
    super.initState();

    _swapController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 420,
      ),
    );
  }

  @override
  void dispose() {
    _swapController.dispose();
    super.dispose();
  }

  // ==========================================================
  // MOUSE ENTER
  // ==========================================================

  void _onEnter(
    PointerEnterEvent event,
  ) {
    setState(() {
      _hovering = true;
      _isSpiderMan = true;
    });

    _swapController.forward();
  }

  // ==========================================================
  // MOUSE MOVE
  // ==========================================================

  void _onHover(
    PointerHoverEvent event,
    BoxConstraints constraints,
  ) {
    if (!_hovering) {
      return;
    }

    if (constraints.maxWidth <= 0 ||
        constraints.maxHeight <= 0) {
      return;
    }

    final double centerX =
        constraints.maxWidth / 2;

    final double centerY =
        constraints.maxHeight / 2;

    final double dx =
        event.localPosition.dx -
            centerX;

    final double dy =
        event.localPosition.dy -
            centerY;

    final double normalizedX =
        (dx / centerX).clamp(
      -1.0,
      1.0,
    );

    final double normalizedY =
        (dy / centerY).clamp(
      -1.0,
      1.0,
    );

    setState(() {
      _rotationY =
          normalizedX * 0.055;

      _rotationX =
          -normalizedY * 0.055;
    });
  }

  // ==========================================================
  // MOUSE EXIT
  // ==========================================================

  void _onExit(
    PointerExitEvent event,
  ) {
    setState(() {
      _hovering = false;
      _isSpiderMan = false;
      _rotationX = 0;
      _rotationY = 0;
    });

    _swapController.reverse();
  }

  // ==========================================================
  // MOBILE TAP
  // ==========================================================

  void _onMobileTap() {
    if (_isSpiderMan) {
      setState(() {
        _isSpiderMan = false;
      });

      _swapController.reverse();
    } else {
      setState(() {
        _isSpiderMan = true;
      });

      _swapController.forward();
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final double width =
        widget.compact ? 250 : 315;

    final double height =
        widget.compact ? 315 : 395;

    return Center(
      child: LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          return MouseRegion(
            cursor:
                SystemMouseCursors.basic,
            onEnter: _onEnter,
            onHover: (event) {
              _onHover(
                event,
                constraints,
              );
            },
            onExit: _onExit,
            child: GestureDetector(
              behavior:
                  HitTestBehavior.opaque,
              onTap: () {
                if (MediaQuery.of(context)
                        .size
                        .width <
                    850) {
                  _onMobileTap();
                }
              },
              child: AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 250,
                ),
                curve: Curves.easeOut,
                width: width,
                height: height,
                transform:
                    Matrix4.identity()
                      ..setEntry(
                        3,
                        2,
                        0.0012,
                      )
                      ..rotateX(
                        _rotationX,
                      )
                      ..rotateY(
                        _rotationY,
                      ),
                transformAlignment:
                    Alignment.center,
                decoration:
                    BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(
                    24,
                  ),
                  border: Border.all(
                    color: _hovering
                        ? kAboutPink
                        : kAboutBorder,
                    width:
                        _hovering
                            ? 1.5
                            : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          kAboutPink.withValues(
                        alpha: _hovering
                            ? 0.22
                            : 0.06,
                      ),
                      blurRadius:
                          _hovering
                              ? 35
                              : 22,
                      spreadRadius:
                          _hovering
                              ? 2
                              : 0,
                    ),
                    BoxShadow(
                      color:
                          Colors.black
                              .withValues(
                        alpha: 0.45,
                      ),
                      blurRadius: 35,
                      offset:
                          const Offset(
                        0,
                        20,
                      ),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    23,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ==================================================
                      // FOTO ANINDYA
                      // ==================================================

                      AnimatedOpacity(
                        duration:
                            const Duration(
                          milliseconds: 320,
                        ),
                        curve:
                            Curves.easeInOut,
                        opacity:
                            _isSpiderMan
                                ? 0.0
                                : 1.0,
                        child:
                            Image.asset(
                          'assets/images/fotowisudaanindya.jpeg',
                          fit: BoxFit.cover,
                          alignment:
                              Alignment.topCenter,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              color:
                                  kAboutSurfaceLight,
                              alignment:
                                  Alignment.center,
                              child:
                                  const Icon(
                                Icons
                                    .person_outline_rounded,
                                color:
                                    kAboutMuted,
                                size: 65,
                              ),
                            );
                          },
                        ),
                      ),

                      // ==================================================
                      // FOTO SPIDER-MAN
                      // ==================================================

                      AnimatedOpacity(
                        duration:
                            const Duration(
                          milliseconds: 320,
                        ),
                        curve:
                            Curves.easeInOut,
                        opacity:
                            _isSpiderMan
                                ? 1.0
                                : 0.0,
                        child:
                            Image.asset(
                          'assets/images/spiderman.jpeg',
                          fit: BoxFit.cover,
                          alignment:
                              Alignment.center,
                          errorBuilder: (
                            context,
                            error,
                            stackTrace,
                          ) {
                            return Container(
                              color:
                                  kAboutSurfaceLight,
                              alignment:
                                  Alignment.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  const Icon(
                                    Icons
                                        .image_not_supported_outlined,
                                    color:
                                        kAboutMuted,
                                    size: 45,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'SPIDER-MAN',
                                    style:
                                        GoogleFonts
                                            .spaceMono(
                                      color:
                                          kAboutMuted,
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
                          },
                        ),
                      ),

                      // ==================================================
                      // IMAGE GRADIENT
                      // ==================================================

                      Positioned.fill(
                        child:
                            IgnorePointer(
                          child:
                              AnimatedContainer(
                            duration:
                                const Duration(
                              milliseconds: 300,
                            ),
                            decoration:
                                BoxDecoration(
                              gradient:
                                  LinearGradient(
                                begin:
                                    Alignment
                                        .topCenter,
                                end:
                                    Alignment
                                        .bottomCenter,
                                colors: [
                                  Colors
                                      .transparent,
                                  Colors.black
                                      .withValues(
                                    alpha:
                                        _isSpiderMan
                                            ? 0.10
                                            : 0.04,
                                  ),
                                  Colors.black
                                      .withValues(
                                    alpha: 0.72,
                                  ),
                                ],
                                stops:
                                    const [
                                  0.35,
                                  0.68,
                                  1.0,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ==================================================
                      // TOP LABEL
                      // ==================================================

                      Positioned(
                        top: 16,
                        left: 16,
                        right: 16,
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration:
                                  const Duration(
                                milliseconds: 250,
                              ),
                              width: 7,
                              height: 7,
                              decoration:
                                  BoxDecoration(
                                color:
                                    kAboutPink,
                                shape:
                                    BoxShape
                                        .circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        kAboutPink
                                            .withValues(
                                      alpha:
                                          0.65,
                                    ),
                                    blurRadius:
                                        10,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Text(
                              _isSpiderMan
                                  ? 'IDENTITY SWAPPED'
                                  : 'ABOUT ME',
                              style:
                                  GoogleFonts
                                      .spaceMono(
                                color:
                                    kAboutWhite,
                                fontSize: 7,
                                fontWeight:
                                    FontWeight
                                        .w700,
                                letterSpacing:
                                    1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// VIEW CV BUTTON
// ============================================================

class _ViewCvButton
    extends StatefulWidget {
  const _ViewCvButton();

  @override
  State<_ViewCvButton> createState() =>
      _ViewCvButtonState();
}

class _ViewCvButtonState
    extends State<_ViewCvButton> {
  bool hovering = false;

  void _openCvViewer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            const CvViewerPage(),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return MouseRegion(
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
        onTap: _openCvViewer,
        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 180,
          ),
          curve: Curves.easeOut,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 13,
          ),
          decoration:
              BoxDecoration(
            color: hovering
                ? kAboutPink
                : kAboutPink.withValues(
                    alpha: 0.10,
                  ),
            borderRadius:
                BorderRadius.circular(
              100,
            ),
            border: Border.all(
              color: kAboutPink,
              width: 1,
            ),
            boxShadow: hovering
                ? [
                    BoxShadow(
                      color:
                          kAboutPink.withValues(
                        alpha: 0.28,
                      ),
                      blurRadius: 22,
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                Icons.description_outlined,
                color: hovering
                    ? kAboutBackground
                    : kAboutPink,
                size: 17,
              ),

              const SizedBox(
                width: 9,
              ),

              Text(
                'LIHAT CV',
                style:
                    GoogleFonts.spaceMono(
                  color: hovering
                      ? kAboutBackground
                      : kAboutWhite,
                  fontSize: 9,
                  fontWeight:
                      FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              Icon(
                Icons.arrow_forward_rounded,
                color: hovering
                    ? kAboutBackground
                    : kAboutPink,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
