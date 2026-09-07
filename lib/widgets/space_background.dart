import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SpaceBackground extends StatefulWidget {
  final Widget child;

  const SpaceBackground({
    super.key,
    required this.child,
  });

  @override
  State<SpaceBackground> createState() =>
      _SpaceBackgroundState();
}

class _SpaceBackgroundState
    extends State<SpaceBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  Offset _mouse = Offset.zero;
  bool _mouseInside = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 12,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateMouse(
    PointerHoverEvent event,
  ) {
    final RenderBox? box =
        context.findRenderObject() as RenderBox?;

    if (box == null || !box.hasSize) {
      return;
    }

    final Size size = box.size;

    setState(() {
      _mouseInside = true;

      _mouse = Offset(
        ((event.localPosition.dx / size.width) * 2 - 1)
            .clamp(-1.0, 1.0),
        ((event.localPosition.dy / size.height) * 2 - 1)
            .clamp(-1.0, 1.0),
      );
    });
  }

  void _mouseExit() {
    setState(() {
      _mouseInside = false;
      _mouse = Offset.zero;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return MouseRegion(
      onHover: _updateMouse,
      onExit: (_) => _mouseExit(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ======================================================
          // BASE
          // ======================================================

          const Positioned.fill(
            child: ColoredBox(
              color: Color(0xFF08070D),
            ),
          ),

          // ======================================================
          // CONTENT
          // ======================================================

          Positioned.fill(
            child: widget.child,
          ),

          // ======================================================
          // SPACE + CURSOR LIGHT
          // ======================================================

          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (
                    context,
                    child,
                  ) {
                    return CustomPaint(
                      painter: _SpacePainter(
                        progress:
                            _controller.value,
                        mouse: _mouse,
                        mouseInside:
                            _mouseInside,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SPACE PAINTER
// ================================================================

class _SpacePainter
    extends CustomPainter {
  final double progress;
  final Offset mouse;
  final bool mouseInside;

  const _SpacePainter({
    required this.progress,
    required this.mouse,
    required this.mouseInside,
  });

  static const Color purple =
      Color(0xFF7657FF);

  static const Color blue =
      Color(0xFF527DFF);

  static const Color cyan =
      Color(0xFF42D8D0);

  static const Color pink =
      Color(0xFFE94D9C);

  static const Color lime =
      Color(0xFFB8E06A);

  static const Color white =
      Color(0xFFF4F1FF);

  static final List<_Star> stars =
      _createStars();

  static List<_Star> _createStars() {
    final math.Random random =
        math.Random(2026);

    return List.generate(
      220,
      (index) {
        final bool twinkle =
            index % 3 != 0;

        return _Star(
          x: random.nextDouble(),
          y: random.nextDouble(),
          radius:
              0.35 +
              random.nextDouble() * 1.25,
          opacity:
              0.12 +
              random.nextDouble() * 0.40,
          phase:
              random.nextDouble() *
              math.pi *
              2,
          speed:
              twinkle
                  ? 0.45 +
                      random.nextDouble() * 1.7
                  : 0.15 +
                      random.nextDouble() * 0.35,
          twinkle: twinkle,
          parallax:
              0.3 +
              random.nextDouble() * 1.7,
        );
      },
    );
  }

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    _drawNebula(
      canvas,
      size,
    );

    _drawStars(
      canvas,
      size,
    );

    _drawSpecialStars(
      canvas,
      size,
    );

    _drawCursorGlow(
      canvas,
      size,
    );

    _drawSubtleGrid(
      canvas,
      size,
    );

    _drawVignette(
      canvas,
      size,
    );
  }

  // ================================================================
  // NEBULA
  // ================================================================

  void _drawNebula(
    Canvas canvas,
    Size size,
  ) {
    final double t =
        progress * math.pi * 2;

    _glow(
      canvas,
      Offset(
        size.width * 0.08 +
            mouse.dx * 22,
        size.height * 0.18 +
            mouse.dy * 15,
      ),
      size.width * 0.42,
      purple,
      0.055,
    );

    _glow(
      canvas,
      Offset(
        size.width * 0.90 -
            mouse.dx * 18,
        size.height * 0.28 -
            mouse.dy * 12,
      ),
      size.width * 0.38,
      blue,
      0.050,
    );

    _glow(
      canvas,
      Offset(
        size.width *
            (0.50 +
                math.sin(t * 0.22) *
                    0.05),
        size.height * 0.52,
      ),
      size.width * 0.45,
      cyan,
      0.032,
    );

    _glow(
      canvas,
      Offset(
        size.width * 0.24,
        size.height * 0.82,
      ),
      size.width * 0.35,
      pink,
      0.025,
    );

    _glow(
      canvas,
      Offset(
        size.width * 0.78,
        size.height * 0.76,
      ),
      size.width * 0.40,
      purple,
      0.030,
    );
  }

  void _glow(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double opacity,
  ) {
    final Paint paint =
        Paint()
          ..shader =
              RadialGradient(
            colors: [
              color.withValues(
                alpha: opacity,
              ),
              color.withValues(
                alpha:
                    opacity * 0.38,
              ),
              Colors.transparent,
            ],
            stops: const [
              0.0,
              0.40,
              1.0,
            ],
          ).createShader(
            Rect.fromCircle(
              center: center,
              radius: radius,
            ),
          );

    canvas.drawCircle(
      center,
      radius,
      paint,
    );
  }

  // ================================================================
  // CURSOR LIGHT
  // ================================================================

  void _drawCursorGlow(
    Canvas canvas,
    Size size,
  ) {
    if (!mouseInside) {
      return;
    }

    // Ubah koordinat normal -1..1
    // menjadi posisi pixel sebenarnya.
    final Offset center =
        Offset(
      ((mouse.dx + 1) / 2) *
          size.width,
      ((mouse.dy + 1) / 2) *
          size.height,
    );

    // ============================================================
    // OUTER SOFT LIGHT
    // ============================================================

    final double outerRadius =
        math.min(
              size.width,
              size.height,
            ) *
            0.32;

    final Paint outerGlow =
        Paint()
          ..shader =
              RadialGradient(
            colors: [
              purple.withValues(
                alpha: 0.075,
              ),
              blue.withValues(
                alpha: 0.040,
              ),
              cyan.withValues(
                alpha: 0.018,
              ),
              Colors.transparent,
            ],
            stops: const [
              0.0,
              0.28,
              0.55,
              1.0,
            ],
          ).createShader(
            Rect.fromCircle(
              center: center,
              radius: outerRadius,
            ),
          );

    canvas.drawCircle(
      center,
      outerRadius,
      outerGlow,
    );

    // ============================================================
    // COLORED INNER LIGHT
    // ============================================================

    final double innerRadius =
        math.min(
              size.width,
              size.height,
            ) *
            0.13;

    final Paint innerGlow =
        Paint()
          ..shader =
              RadialGradient(
            colors: [
              white.withValues(
                alpha: 0.13,
              ),
              cyan.withValues(
                alpha: 0.075,
              ),
              purple.withValues(
                alpha: 0.035,
              ),
              Colors.transparent,
            ],
            stops: const [
              0.0,
              0.20,
              0.55,
              1.0,
            ],
          ).createShader(
            Rect.fromCircle(
              center: center,
              radius: innerRadius,
            ),
          );

    canvas.drawCircle(
      center,
      innerRadius,
      innerGlow,
    );

    // ============================================================
    // SMALL CORE
    // ============================================================

    final Paint coreGlow =
        Paint()
          ..color =
              white.withValues(
            alpha: 0.13,
          )
          ..maskFilter =
              const MaskFilter.blur(
            BlurStyle.normal,
            7,
          );

    canvas.drawCircle(
      center,
      7,
      coreGlow,
    );

    // ============================================================
    // TINY CROSS LIGHT
    // ============================================================

    final double pulse =
        0.6 +
        ((math.sin(
                    progress *
                        math.pi *
                        2 *
                        1.8,
                  ) +
                  1) /
              2) *
            0.4;

    final Paint cross =
        Paint()
          ..color =
              white.withValues(
            alpha:
                0.08 * pulse,
          )
          ..strokeWidth = 0.7
          ..strokeCap =
              StrokeCap.round;

    canvas.drawLine(
      Offset(
        center.dx - 10,
        center.dy,
      ),
      Offset(
        center.dx + 10,
        center.dy,
      ),
      cross,
    );

    canvas.drawLine(
      Offset(
        center.dx,
        center.dy - 10,
      ),
      Offset(
        center.dx,
        center.dy + 10,
      ),
      cross,
    );
  }

  // ================================================================
  // STARS
  // ================================================================

  void _drawStars(
    Canvas canvas,
    Size size,
  ) {
    for (final _Star star in stars) {
      final double x =
          star.x * size.width +
          mouse.dx *
              star.parallax *
              4;

      final double y =
          star.y * size.height +
          mouse.dy *
              star.parallax *
              3;

      double alpha;

      if (star.twinkle) {
        final double wave =
            math.sin(
                  progress *
                          math.pi *
                          2 *
                          star.speed +
                      star.phase,
                );

        final double normalized =
            (wave + 1) / 2;

        alpha =
            star.opacity *
            (0.22 +
                normalized * 0.78);
      } else {
        alpha =
            star.opacity * 0.62;
      }

      final Paint paint =
          Paint()
            ..color =
                white.withValues(
              alpha:
                  alpha.clamp(
                0.0,
                0.75,
              ),
            );

      canvas.drawCircle(
        Offset(x, y),
        star.radius,
        paint,
      );

      // ==========================================================
      // STAR GLOW
      // ==========================================================

      if (star.radius > 1.05 &&
          star.twinkle) {
        final double wave =
            math.sin(
                  progress *
                          math.pi *
                          2 *
                          star.speed +
                      star.phase,
                );

        if (wave > 0.55) {
          final double glowAlpha =
              ((wave - 0.55) /
                      0.45) *
                  0.12;

          final Paint glow =
              Paint()
                ..color =
                    white.withValues(
                  alpha:
                      glowAlpha,
                )
                ..maskFilter =
                    const MaskFilter.blur(
                  BlurStyle.normal,
                  4,
                );

          canvas.drawCircle(
            Offset(x, y),
            star.radius * 3.2,
            glow,
          );
        }
      }
    }
  }

  // ================================================================
  // SPECIAL STARS
  // ================================================================

  void _drawSpecialStars(
    Canvas canvas,
    Size size,
  ) {
    final List<_SpecialStar>
        special = [
      _SpecialStar(
        x: 0.13,
        y: 0.18,
        size: 4.5,
        color: cyan,
        speed: 0.8,
        phase: 0.0,
      ),
      _SpecialStar(
        x: 0.82,
        y: 0.16,
        size: 4.0,
        color: purple,
        speed: 0.65,
        phase: 2.0,
      ),
      _SpecialStar(
        x: 0.72,
        y: 0.48,
        size: 5.0,
        color: white,
        speed: 0.55,
        phase: 4.0,
      ),
      _SpecialStar(
        x: 0.24,
        y: 0.68,
        size: 3.8,
        color: pink,
        speed: 0.75,
        phase: 1.5,
      ),
      _SpecialStar(
        x: 0.91,
        y: 0.78,
        size: 4.2,
        color: blue,
        speed: 0.60,
        phase: 5.0,
      ),
      _SpecialStar(
        x: 0.48,
        y: 0.30,
        size: 3.5,
        color: cyan,
        speed: 0.70,
        phase: 3.0,
      ),
      _SpecialStar(
        x: 0.57,
        y: 0.87,
        size: 3.8,
        color: lime,
        speed: 0.58,
        phase: 4.8,
      ),
    ];

    for (final _SpecialStar star
        in special) {
      final double pulse =
          (math.sin(
                    progress *
                            math.pi *
                            2 *
                            star.speed +
                        star.phase,
                  ) +
                  1) /
              2;

      final double scale =
          0.55 + pulse * 0.75;

      final Offset center =
          Offset(
        star.x * size.width +
            mouse.dx * 5,
        star.y * size.height +
            mouse.dy * 4,
      );

      // ==========================================================
      // GLOW
      // ==========================================================

      final Paint glow =
          Paint()
            ..color =
                star.color.withValues(
              alpha:
                  0.045 +
                  pulse * 0.09,
            )
            ..maskFilter =
                const MaskFilter.blur(
              BlurStyle.normal,
              7,
            );

      canvas.drawCircle(
        center,
        star.size * 2.8 * scale,
        glow,
      );

      // ==========================================================
      // FOUR POINT STAR
      // ==========================================================

      final Path path =
          Path();

      final double s =
          star.size * scale;

      path.moveTo(
        center.dx,
        center.dy - s * 2.2,
      );

      path.quadraticBezierTo(
        center.dx + s * 0.30,
        center.dy - s * 0.30,
        center.dx + s * 2.2,
        center.dy,
      );

      path.quadraticBezierTo(
        center.dx + s * 0.30,
        center.dy + s * 0.30,
        center.dx,
        center.dy + s * 2.2,
      );

      path.quadraticBezierTo(
        center.dx - s * 0.30,
        center.dy + s * 0.30,
        center.dx - s * 2.2,
        center.dy,
      );

      path.quadraticBezierTo(
        center.dx - s * 0.30,
        center.dy - s * 0.30,
        center.dx,
        center.dy - s * 2.2,
      );

      path.close();

      final Paint paint =
          Paint()
            ..color =
                star.color.withValues(
              alpha:
                  0.25 +
                  pulse * 0.48,
            );

      canvas.drawPath(
        path,
        paint,
      );

      final Paint core =
          Paint()
            ..color =
                white.withValues(
              alpha:
                  0.40 +
                  pulse * 0.48,
            );

      canvas.drawCircle(
        center,
        0.8 + pulse * 0.8,
        core,
      );
    }
  }

  // ================================================================
  // SUBTLE GRID
  // ================================================================

  void _drawSubtleGrid(
    Canvas canvas,
    Size size,
  ) {
    final Paint paint =
        Paint()
          ..color =
              Colors.white.withValues(
            alpha: 0.005,
          )
          ..strokeWidth = 1;

    const double spacing = 60;

    for (
      double x = 0;
      x <= size.width;
      x += spacing
    ) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(
          x,
          size.height,
        ),
        paint,
      );
    }

    for (
      double y = 0;
      y <= size.height;
      y += spacing
    ) {
      canvas.drawLine(
        Offset(0, y),
        Offset(
          size.width,
          y,
        ),
        paint,
      );
    }
  }

  // ================================================================
  // VIGNETTE
  // ================================================================

  void _drawVignette(
    Canvas canvas,
    Size size,
  ) {
    final Paint paint =
        Paint()
          ..shader =
              RadialGradient(
            center:
                Alignment.center,
            radius: 0.95,
            colors: [
              Colors.transparent,
              Colors.transparent,
              Colors.black.withValues(
                alpha: 0.14,
              ),
            ],
            stops: const [
              0.45,
              0.78,
              1.0,
            ],
          ).createShader(
            Offset.zero & size,
          );

    canvas.drawRect(
      Offset.zero & size,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _SpacePainter oldDelegate,
  ) {
    return oldDelegate.progress !=
            progress ||
        oldDelegate.mouse != mouse ||
        oldDelegate.mouseInside !=
            mouseInside;
  }
}

// ================================================================
// STAR MODEL
// ================================================================

class _Star {
  final double x;
  final double y;
  final double radius;
  final double opacity;
  final double phase;
  final double speed;
  final bool twinkle;
  final double parallax;

  const _Star({
    required this.x,
    required this.y,
    required this.radius,
    required this.opacity,
    required this.phase,
    required this.speed,
    required this.twinkle,
    required this.parallax,
  });
}

// ================================================================
// SPECIAL STAR MODEL
// ================================================================

class _SpecialStar {
  final double x;
  final double y;
  final double size;
  final Color color;
  final double speed;
  final double phase;

  const _SpecialStar({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.phase,
  });
}