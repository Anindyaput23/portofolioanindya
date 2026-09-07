import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'portofolio_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage>
    with TickerProviderStateMixin {
  // ==========================================================
  // CONTROLLERS
  // ==========================================================

  late final AnimationController _orbController;

  late final AnimationController _pulseController;

  late final AnimationController _enterController;

  // ==========================================================
  // STATE
  // ==========================================================

  bool _entering = false;

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color background =
      Color(0xFF080A10);

  static const Color white =
      Color(0xFFF5F7FF);

  static const Color muted =
      Color(0xFF9299AB);

  static const Color pink =
      Color(0xFFFF4FA3);

  static const Color purple =
      Color(0xFF7C5CFF);

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // ORBIT ROTATION
    // ==========================================================

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 8000,
      ),
    )..repeat();

    // ==========================================================
    // ICON PULSE
    // ==========================================================

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ),
    )..repeat(
        reverse: true,
      );

    // ==========================================================
    // ENTER TRANSITION
    // ==========================================================

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 450,
      ),
    );
  }

  // ==========================================================
  // ENTER PORTFOLIO
  // ==========================================================

  Future<void> _enterPortfolio() async {
    if (_entering) {
      return;
    }

    setState(() {
      _entering = true;
    });

    await _enterController.forward();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration:
            const Duration(
          milliseconds: 700,
        ),

        reverseTransitionDuration:
            const Duration(
          milliseconds: 450,
        ),

        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) {
          return const PortfolioPage();
        },

        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          // ========================================================
          // PORTFOLIO MASUK DARI ATAS KE BAWAH
          // ========================================================

          final Animation<double>
              curvedAnimation =
              CurvedAnimation(
            parent: animation,
            curve:
                Curves.easeOutCubic,
            reverseCurve:
                Curves.easeInCubic,
          );

          return SlideTransition(
            position:
                Tween<Offset>(
              begin:
                  const Offset(
                0,
                -1,
              ),
              end:
                  Offset.zero,
            ).animate(
              curvedAnimation,
            ),

            child:
                child,
          );
        },
      ),
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _orbController.dispose();
    _pulseController.dispose();
    _enterController.dispose();

    super.dispose();
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          background,

      body:
          LayoutBuilder(
        builder: (
          context,
          constraints,
        ) {
          final bool mobile =
              constraints.maxWidth < 700;

          return Stack(
            fit:
                StackFit.expand,

            children: [
              // ==========================================================
              // BACKGROUND
              // ==========================================================

              const Positioned.fill(
                child:
                    CustomPaint(
                  painter:
                      _SpaceBackgroundPainter(),
                ),
              ),

              // ==========================================================
              // ORBIT
              // ==========================================================

              AnimatedBuilder(
                animation:
                    _orbController,

                builder: (
                  context,
                  child,
                ) {
                  return CustomPaint(
                    painter:
                        _OrbitPainter(
                      progress:
                          _orbController.value,
                      mobile:
                          mobile,
                    ),
                  );
                },
              ),

              // ==========================================================
              // CONTENT
              // ==========================================================

              SafeArea(
                child:
                    Padding(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal:
                        mobile
                            ? 22
                            : 55,

                    vertical:
                        mobile
                            ? 22
                            : 30,
                  ),

                  child:
                      Column(
                    children: [
                      // ==================================================
                      // CENTER
                      // ==================================================

                      Expanded(
                        child:
                            Center(
                          child:
                              SingleChildScrollView(
                            physics:
                                const NeverScrollableScrollPhysics(),

                            child:
                                _buildCenter(
                              context,
                              mobile,
                            ),
                          ),
                        ),
                      ),

                      // ==================================================
                      // BOTTOM
                      // ==================================================

                      _buildBottom(
                        mobile,
                      ),
                    ],
                  ),
                ),
              ),

              // ==========================================================
              // ENTER OVERLAY
              // ==========================================================

              if (_entering)
                Positioned.fill(
                  child:
                      IgnorePointer(
                    child:
                        AnimatedBuilder(
                      animation:
                          _enterController,

                      builder: (
                        context,
                        child,
                      ) {
                        final double value =
                            _enterController
                                .value;

                        return Container(
                          color:
                              background
                                  .withOpacity(
                            value *
                                0.10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // ==========================================================
  // CENTER
  // ==========================================================

  Widget _buildCenter(
    BuildContext context,
    bool mobile,
  ) {
    return Column(
      mainAxisSize:
          MainAxisSize.min,

      children: [
        // ======================================================
        // WELCOME
        // ======================================================

        Text(
          'WELCOME',

          textAlign:
              TextAlign.center,

          style:
              GoogleFonts.unbounded(
            color:
                white,

            fontSize:
                mobile
                    ? 34
                    : 56,

            fontWeight:
                FontWeight.w700,

            letterSpacing:
                mobile
                    ? 1.5
                    : 3.0,

            height:
                1.0,
          ),
        ),

        SizedBox(
          height:
              mobile
                  ? 12
                  : 15,
        ),

        // ======================================================
        // TO MY PORTFOLIO
        // ======================================================

        Text(
          'TO MY PORTFOLIO',

          textAlign:
              TextAlign.center,

          style:
              GoogleFonts.spaceMono(
            color:
                muted,

            fontSize:
                mobile
                    ? 8
                    : 10,

            fontWeight:
                FontWeight.w500,

            letterSpacing:
                mobile
                    ? 2.2
                    : 3.8,
          ),
        ),

        SizedBox(
          height:
              mobile
                  ? 32
                  : 44,
        ),

        // ======================================================
        // CODE ICON
        // ======================================================

        AnimatedBuilder(
          animation:
              Listenable.merge([
            _pulseController,
            _enterController,
          ]),

          builder: (
            context,
            child,
          ) {
            final double pulse =
                _pulseController.value;

            final double enter =
                _enterController.value;

            final double scale =
                1.0 +
                    (pulse *
                        .025) +
                    (enter *
                        .07);

            final double rotation =
                enter *
                    .08;

            final double opacity =
                1.0 -
                    (enter *
                        .30);

            return Opacity(
              opacity:
                  opacity,

              child:
                  Transform.rotate(
                angle:
                    rotation,

                child:
                    Transform.scale(
                  scale:
                      scale,

                  child:
                      child,
                ),
              ),
            );
          },

          child:
              GestureDetector(
            onTap:
                _enterPortfolio,

            child:
                MouseRegion(
              cursor:
                  SystemMouseCursors
                      .click,

              child:
                  _CodeOrb(
                mobile:
                    mobile,
              ),
            ),
          ),
        ),

        SizedBox(
          height:
              mobile
                  ? 25
                  : 34,
        ),

        // ======================================================
        // CLICK TEXT
        // ======================================================

        AnimatedBuilder(
          animation:
              _pulseController,

          builder: (
            context,
            child,
          ) {
            final double opacity =
                0.52 +
                    (_pulseController
                            .value *
                        0.32);

            return Opacity(
              opacity:
                  opacity,

              child:
                  child,
            );
          },

          child:
              Text(
            'CLICK THE ICON TO START',

            textAlign:
                TextAlign.center,

            style:
                GoogleFonts
                    .spaceMono(
              color:
                  white.withOpacity(
                0.80,
              ),

              fontSize:
                  mobile
                      ? 8
                      : 9,

              fontWeight:
                  FontWeight.w600,

              letterSpacing:
                  mobile
                      ? 2.0
                      : 3.0,
            ),
          ),
        ),

        const SizedBox(
          height:
              9,
        ),

        // ======================================================
        // ARROW
        // ======================================================

        AnimatedBuilder(
          animation:
              _pulseController,

          builder: (
            context,
            child,
          ) {
            final double offset =
                math.sin(
                      _pulseController.value *
                          math.pi,
                    ) *
                    2.5;

            return Transform.translate(
              offset:
                  Offset(
                0,
                offset,
              ),

              child:
                  child,
            );
          },

          child:
              const Icon(
            Icons
                .keyboard_arrow_down_rounded,

            color:
                pink,

            size:
                17,
          ),
        ),

        SizedBox(
          height:
              mobile
                  ? 28
                  : 40,
        ),

        // ======================================================
        // TAGLINE
        // ======================================================

        Wrap(
          alignment:
              WrapAlignment.center,

          children: [
            const _MetaText(
              text:
                  'IDEAS',
            ),

            const _MetaArrow(
              color:
                  pink,
            ),

            const _MetaText(
              text:
                  'CODE',
            ),

            const _MetaArrow(
              color:
                  purple,
            ),

            const _MetaText(
              text:
                  'REAL IMPACT',
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================
  // BOTTOM
  // ==========================================================

  Widget _buildBottom(
    bool mobile,
  ) {
    return const SizedBox(
      height:
          2,
    );
  }
}

// ============================================================================
// META TEXT
// ============================================================================

class _MetaText
    extends StatelessWidget {
  final String text;

  const _MetaText({
    required this.text,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal:
            5,
      ),

      child:
          Text(
        text,

        style:
            const TextStyle(
          color:
              Color(
            0xFF9299AB,
          ),

          fontSize:
              7,

          fontWeight:
              FontWeight.w600,

          letterSpacing:
              1.6,

          fontFamily:
              'monospace',
        ),
      ),
    );
  }
}

// ============================================================================
// META ARROW
// ============================================================================

class _MetaArrow
    extends StatelessWidget {
  final Color color;

  const _MetaArrow({
    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Padding(
      padding:
          const EdgeInsets
              .symmetric(
        horizontal:
            3,
      ),

      child:
          Text(
        '→',

        style:
            TextStyle(
          color:
              color,

          fontSize:
              8,

          fontWeight:
              FontWeight.w700,

          fontFamily:
              'monospace',
        ),
      ),
    );
  }
}

// ============================================================================
// CODE ORB
// ============================================================================

class _CodeOrb
    extends StatelessWidget {
  final bool mobile;

  const _CodeOrb({
    required this.mobile,
  });

  static const Color pink =
      Color(0xFFFF4FA3);

  static const Color purple =
      Color(0xFF7C5CFF);

  static const Color blue =
      Color(0xFF4F7CFF);

  static const Color lime =
      Color(0xFFA8FF3E);

  static const Color white =
      Color(0xFFF5F7FF);

  @override
  Widget build(
    BuildContext context,
  ) {
    final double size =
        mobile
            ? 148
            : 182;

    return SizedBox(
      width:
          size,

      height:
          size,

      child:
          Stack(
        alignment:
            Alignment.center,

        children: [
          // ========================================================
          // GLOW
          // ========================================================

          Container(
            width:
                size * .66,

            height:
                size * .66,

            decoration:
                BoxDecoration(
              shape:
                  BoxShape.circle,

              color:
                  purple.withOpacity(
                .06,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      pink.withOpacity(
                    .17,
                  ),

                  blurRadius:
                      35,

                  spreadRadius:
                      8,
                ),
              ],
            ),
          ),

          // ========================================================
          // ORBIT 1
          // ========================================================

          Container(
            width:
                size * .88,

            height:
                size * .44,

            decoration:
                BoxDecoration(
              border:
                  Border.all(
                color:
                    white.withOpacity(
                  .17,
                ),

                width:
                    1,
              ),

              borderRadius:
                  BorderRadius.circular(
                999,
              ),
            ),
          ),

          // ========================================================
          // ORBIT 2
          // ========================================================

          Transform.rotate(
            angle:
                -.55,

            child:
                Container(
              width:
                  size * .78,

              height:
                  size * .48,

              decoration:
                  BoxDecoration(
                border:
                    Border.all(
                  color:
                      purple.withOpacity(
                    .27,
                  ),

                  width:
                      1,
                ),

                borderRadius:
                    BorderRadius.circular(
                  999,
                ),
              ),
            ),
          ),

          // ========================================================
          // CENTER GRADIENT
          // ========================================================

          Container(
            width:
                size * .50,

            height:
                size * .50,

            padding:
                EdgeInsets.all(
              size * .055,
            ),

            decoration:
                BoxDecoration(
              gradient:
                  const LinearGradient(
                begin:
                    Alignment.topLeft,

                end:
                    Alignment.bottomRight,

                colors: [
                  pink,
                  purple,
                  blue,
                ],
              ),

              borderRadius:
                  BorderRadius.circular(
                25,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      pink.withOpacity(
                    .27,
                  ),

                  blurRadius:
                      30,

                  spreadRadius:
                      3,
                ),
              ],
            ),

            child:
                ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                19,
              ),

              child:
                  Container(
                width:
                    double.infinity,

                height:
                    double.infinity,

                decoration:
                    BoxDecoration(
                  color:
                      const Color(
                    0xFF171320,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                    19,
                  ),

                  border:
                      Border.all(
                    color:
                        white.withOpacity(
                      .08,
                    ),

                    width:
                        1,
                  ),

                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black
                              .withOpacity(
                        .30,
                      ),

                      blurRadius:
                          18,
                    ),
                  ],
                ),

                child:
                    FittedBox(
                  fit:
                      BoxFit.scaleDown,

                  child:
                      _CodeSymbol(
                    size:
                        size,
                  ),
                ),
              ),
            ),
          ),

          // ========================================================
          // PINK DOT
          // ========================================================

          Positioned(
            top:
                size * .19,

            left:
                size * .09,

            child:
                _OrbDot(
              color:
                  pink,

              size:
                  mobile
                      ? 7
                      : 8,
            ),
          ),

          // ========================================================
          // LIME DOT
          // ========================================================

          Positioned(
            top:
                size * .15,

            right:
                size * .09,

            child:
                _OrbDot(
              color:
                  lime,

              size:
                  mobile
                      ? 7
                      : 8,
            ),
          ),

          // ========================================================
          // BLUE DOT
          // ========================================================

          Positioned(
            bottom:
                size * .13,

            left:
                size * .14,

            child:
                _OrbDot(
              color:
                  blue,

              size:
                  mobile
                      ? 6
                      : 7,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CODE SYMBOL
// ============================================================================

class _CodeSymbol
    extends StatelessWidget {
  final double size;

  const _CodeSymbol({
    required this.size,
  });

  static const Color pink =
      Color(0xFFFF4FA3);

  static const Color purple =
      Color(0xFF7C5CFF);

  static const Color blue =
      Color(0xFF4F7CFF);

  static const Color lime =
      Color(0xFFA8FF3E);

  static const Color white =
      Color(0xFFF5F7FF);

  @override
  Widget build(
    BuildContext context,
  ) {
    return SizedBox(
      width:
          size * .30,

      height:
          size * .27,

      child:
          Column(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceEvenly,

        children: [
          Container(
            width:
                size * .27,

            height:
                2.5,

            decoration:
                BoxDecoration(
              color:
                  lime,

              borderRadius:
                  BorderRadius.circular(
                99,
              ),

              boxShadow: [
                BoxShadow(
                  color:
                      lime.withOpacity(
                    .45,
                  ),

                  blurRadius:
                      7,
                ),
              ],
            ),
          ),

          Text(
            '</>',

            style:
                TextStyle(
              color:
                  white,

              fontSize:
                  size * .14,

              fontWeight:
                  FontWeight.w900,

              height:
                  .9,

              letterSpacing:
                  -2.2,

              shadows: [
                Shadow(
                  color:
                      pink.withOpacity(
                    .65,
                  ),

                  blurRadius:
                      10,
                ),
              ],
            ),
          ),

          Container(
            width:
                size * .30,

            height:
                2.5,

            decoration:
                BoxDecoration(
              color:
                  purple,

              borderRadius:
                  BorderRadius.circular(
                99,
              ),
            ),
          ),

          Container(
            width:
                size * .21,

            height:
                2.5,

            decoration:
                BoxDecoration(
              color:
                  blue.withOpacity(
                .75,
              ),

              borderRadius:
                  BorderRadius.circular(
                99,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// ORB DOT
// ============================================================================

class _OrbDot
    extends StatelessWidget {
  final Color color;
  final double size;

  const _OrbDot({
    required this.color,
    required this.size,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width:
          size,

      height:
          size,

      decoration:
          BoxDecoration(
        color:
            color,

        shape:
            BoxShape.circle,

        boxShadow: [
          BoxShadow(
            color:
                color.withOpacity(
              .60,
            ),

            blurRadius:
                10,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// SPACE BACKGROUND
// ============================================================================

class _SpaceBackgroundPainter
    extends CustomPainter {
  const _SpaceBackgroundPainter();

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Paint paint =
        Paint()
          ..style =
              PaintingStyle.fill;

    // ==========================================================
    // GRID
    // ==========================================================

    final Paint gridPaint =
        Paint()
          ..style =
              PaintingStyle.stroke

          ..strokeWidth =
              .4

          ..color =
              const Color(
            0xFFFFFFFF,
          ).withOpacity(
            .032,
          );

    const double spacing =
        48;

    for (
      double x = 0;
      x <= size.width;
      x += spacing
    ) {
      canvas.drawLine(
        Offset(
          x,
          0,
        ),

        Offset(
          x,
          size.height,
        ),

        gridPaint,
      );
    }

    for (
      double y = 0;
      y <= size.height;
      y += spacing
    ) {
      canvas.drawLine(
        Offset(
          0,
          y,
        ),

        Offset(
          size.width,
          y,
        ),

        gridPaint,
      );
    }

    // ==========================================================
    // STARS
    // ==========================================================

    final List<Offset> stars = [
      Offset(
        size.width * .08,
        size.height * .16,
      ),

      Offset(
        size.width * .15,
        size.height * .72,
      ),

      Offset(
        size.width * .21,
        size.height * .28,
      ),

      Offset(
        size.width * .29,
        size.height * .14,
      ),

      Offset(
        size.width * .35,
        size.height * .80,
      ),

      Offset(
        size.width * .44,
        size.height * .09,
      ),

      Offset(
        size.width * .52,
        size.height * .73,
      ),

      Offset(
        size.width * .60,
        size.height * .17,
      ),

      Offset(
        size.width * .67,
        size.height * .84,
      ),

      Offset(
        size.width * .76,
        size.height * .29,
      ),

      Offset(
        size.width * .83,
        size.height * .12,
      ),

      Offset(
        size.width * .91,
        size.height * .70,
      ),

      Offset(
        size.width * .96,
        size.height * .23,
      ),
    ];

    for (
      int i = 0;
      i < stars.length;
      i++
    ) {
      paint.color =
          const Color(
        0xFFFFFFFF,
      ).withOpacity(
        i.isEven
            ? .14
            : .08,
      );

      canvas.drawCircle(
        stars[i],

        i % 3 == 0
            ? 1.5
            : .9,

        paint,
      );
    }

    // ==========================================================
    // LEFT GLOW
    // ==========================================================

    paint.color =
        const Color(
      0xFFFF4FA3,
    ).withOpacity(
      .045,
    );

    canvas.drawCircle(
      Offset(
        -size.width * .05,
        size.height * .38,
      ),

      size.width * .20,

      paint,
    );

    // ==========================================================
    // RIGHT GLOW
    // ==========================================================

    paint.color =
        const Color(
      0xFF7C5CFF,
    ).withOpacity(
      .045,
    );

    canvas.drawCircle(
      Offset(
        size.width * 1.03,
        size.height * .70,
      ),

      size.width * .22,

      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _SpaceBackgroundPainter
        oldDelegate,
  ) {
    return false;
  }
}

// ============================================================================
// ORBIT
// ============================================================================

class _OrbitPainter
    extends CustomPainter {
  final double progress;
  final bool mobile;

  const _OrbitPainter({
    required this.progress,
    required this.mobile,
  });

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final Offset center =
        Offset(
      size.width * .50,
      size.height * .48,
    );

    final double width =
        mobile
            ? size.width * .80
            : size.width * .62;

    final double height =
        mobile
            ? size.height * .22
            : size.height * .25;

    final Paint orbitPaint =
        Paint()
          ..style =
              PaintingStyle.stroke

          ..strokeWidth =
              .8

          ..color =
              const Color(
            0xFFFF4FA3,
          ).withOpacity(
            .14,
          );

    canvas.save();

    canvas.translate(
      center.dx,
      center.dy,
    );

    canvas.rotate(
      -.12 +
          (progress *
              math.pi *
              .25),
    );

    canvas.drawOval(
      Rect.fromCenter(
        center:
            Offset.zero,

        width:
            width,

        height:
            height,
      ),

      orbitPaint,
    );

    canvas.restore();

    // ==========================================================
    // ORBIT DOT
    // ==========================================================

    final double angle =
        progress *
            math.pi *
            2;

    final double radiusX =
        width / 2;

    final double radiusY =
        height / 2;

    final Offset dot =
        Offset(
      center.dx +
          math.cos(angle) *
              radiusX,

      center.dy +
          math.sin(angle) *
              radiusY,
    );

    final Paint dotPaint =
        Paint()
          ..color =
              const Color(
            0xFFA8FF3E,
          ).withOpacity(
            .75,
          );

    canvas.drawCircle(
      dot,
      2.2,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _OrbitPainter
        oldDelegate,
  ) {
    return oldDelegate
                .progress !=
            progress ||
        oldDelegate.mobile !=
            mobile;
  }
}